/**
 * File name: user_input.js
 * Executes server requests and connects to database
 */


const express = require('express');
const mongodb = require('mongodb');
const router = express.Router();
const exec = require('child_process').exec;
const puppeteer = require('puppeteer');


'use strict';
const fs = require('fs');


//###################################################

//POST requests

//###################################################


// Add userinput to database
router.post('/', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.insertOne({
		timestamp: new Date(),
		input: req.body.input
	});
	res.status(201).send();
});


//###################################################

//GET requests

//###################################################

// Retrieve all user inputs from database
router.get('/', async(req, res) => {
	const user_input = await loadUserInputCollection();
	res.send(await user_input.find({}).toArray());
});


// Get user input by id 
router.get('/get_by_id/:id', async(req, res) => {
	const user_input = await loadUserInputCollection();
	res.send(await user_input.findOne({
		_id: new mongodb.ObjectID(req.params.id)
	}));
});


//###################################################

//Child processes

//###################################################


// Execute child process
function execute(command) {
	exec((command), (error, stdout, stderr) => {

		if (error) {
			console.log(`error: ${error.message}`);
			return;
		}
		if (stderr) {
			console.log(`stderr: ${stderr}`);
			return;
		};
		// console.log(stdout.toString('utf8'))
		console.log(`stdout: ${stdout}`);
		// res.send(stdout);
	});
}


// Run script to create cloudsstorm architecture and create blockchains according to user input
router.get('/create_blockchain/:id', async(req, res) => {
	// Get collection user_input from blockchain_tool database
	const user_input = await loadUserInputCollection();
	// Retrieve input in json format from mongo database by ID
	const input = await user_input.findOne({
		_id: new mongodb.ObjectID(req.params.id)
	});
	const obj = JSON.stringify(input);
	fs.writeFileSync('./server/json_files/input.json', obj);
	// Call script and pass input
	execute(`sudo ./cloud_storm/scripts/configure_blockchain.sh "./server/json_files/input.json"`)

	req.session.block_id = req.params.id

	res.status(201).send();
})


// Get public ip from monitor by id
router.get('/get_pub_ip_by_id/:id', async(req, res) => {

	exec((`sudo ./cloud_storm/scripts/get_ip.sh ${req.params.id}`), (error, stdout, stderr) => {

		if (error) {
			console.log(`error: ${error.message}`);
			return;
		}
		if (stderr) {
			console.log(`stderr: ${stderr}`);
			return;
		};
		// console.log(stdout.toString('utf8'))
		// console.log(`stdout: ${stdout}`);
		// console.log(req.session.pub_ip)
		res.send(stdout);
	});

})


// Delete blockchain in cloud with cloudssstorm by id
router.get('/delete_blockchain/:id', async(req, res) => {
	exec((`sudo ./cloud_storm/scripts/delete_blockchain.sh ${req.params.id}`), (error, stdout, stderr) => {

		if (error) {
			console.log(`error: ${error.message}`);
			return;
		}
		if (stderr) {
			console.log(`stderr: ${stderr}`);
			return;
		};
		res.send(stdout);
	});
});


//###################################################

//PATCH REQUESTS

//###################################################


// Update with monitor ip
router.patch('/add_monitor_ip/:id', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.updateOne(
		// {_id: req.params.id},
		{
			_id: new mongodb.ObjectID(req.params.id)
		}, {
			$set: {
				monitor_ip: req.body.monitor_ip
			}
		},
		// { upsert: true }
	);
	res.status(201).send();
});


// Update with grafana iframe url
router.patch('/add_graf_url/:id', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.updateOne(
		// {_id: req.params.id},
		{
			_id: new mongodb.ObjectID(req.params.id)
		}, {
			$set: {
				graf_url: req.body.graf_url
			}
		},
		// { upsert: true }
	);
	res.status(201).send();
});


// Update with individual grafana graph urls for comparing page
router.patch('/update_input_with_metric_urls/:id', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.updateOne(
		// {_id: req.params.id},
		{
			_id: new mongodb.ObjectID(req.params.id)
		}, {
			$set: {
				metric_urls: req.body.metric_urls
			}
		},
		// { upsert: true }
	);
	res.status(201).send();
});


// Update with transactions
router.patch('/update_input_with_trans', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.updateOne(
		{
			_id: new mongodb.ObjectID(req.session.block_id)
		}, {
			$push: {
				transactions: req.body.trans_id
			}
		},
		// { upsert: true }
	);
	res.status(201).send();
});


//###################################################

//DELETE REQUESTS

//###################################################


// Delete all userinputs
router.delete('/', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.remove({});
	res.status(200).send();
});


// Delete user input by id
router.delete('/delete/:id', async(req, res) => {
	const user_input = await loadUserInputCollection();
	await user_input.deleteOne({
		_id: new mongodb.ObjectID(req.params.id)
	});
	res.status(200).send();
});


//###################################################

//SCRAPING REQUESTS

//###################################################


// Scrape urls to individual grafana graph by automatically logging in to dashboard
router.get('/metric_url/:ip', async(req, res) => {
	let url = `http://${req.params.ip}:3000/login`,
		res_data;
	const browser = await puppeteer.launch({
		headless: false,
		args: ['--ignore-certificate-errors --enable-features=NetworkService', '--no-sandbox', '--disable-setuid-sandbox']
	});
	const page = await browser.newPage();
	const client = await page.target().createCDPSession();
	await client.send('Security.setIgnoreCertificateErrors', {
		ignore: true
	});

	await page.setViewport({
		width: 1450,
		height: 750
	})

	try {
		res_data = [{
			"type": "success"
		}];
		//  Type in the username and password
		// const navigationPromise = page.waitForNavigation()
		await page.goto(url, {
			waitUntil: 'networkidle0'
		}); // wait until page load   
		// await page.waitForNavigation({ waitUntil: 'networkidle0' });
		await page.type('input[name="username"]', "admin");
		await page.type('input[name="password"]', "admin");
		await page.click('button[type="submit"]');

		await page.waitForNavigation({
			waitUntil: 'networkidle0'
		});
		await page.waitFor(20);

		await page.waitForSelector('.navbar > .navbar-inner > .navbar-section-wrapper > .navbar-page-btn > .fa')
		await page.click('.navbar > .navbar-inner > .navbar-section-wrapper > .navbar-page-btn > .fa')

		await page.waitForSelector('.search-dropdown > .search-results-container > .search-item-dash-json > .search-result-link > span')
		await page.click('.search-dropdown > .search-results-container > .search-item-dash-json > .search-result-link > span')

		await page.waitForSelector('.panel-hover-highlight > .panel-header > .panel-title-container > .panel-title > .panel-title-text')
		await page.click('.panel-hover-highlight > .panel-header > .panel-title-container > .panel-title > .panel-title-text')

		await page.waitForSelector('.page-dashboard > .panel-menu > .panel-menu-inner > .panel-menu-row > .panel-menu-link:nth-child(6)')
		await page.click('.page-dashboard > .panel-menu > .panel-menu-inner > .panel-menu-row > .panel-menu-link:nth-child(6)')

		await page.waitForSelector('div > .gf-form-group > .gf-form-inline > .gf-form > .gf-form-input')

		var element = await page.$('div > .gf-form-group > .gf-form-inline > .gf-form > .gf-form-input');
		var block_link = await page.evaluate(element => element.value, element)

		await browser.close();
		// console.log(data.screen_link)
		res.send(block_link);
	} catch (err) {

		console.log("PPTR Error - handled case", err);
		res_data = [{
			"type": "error"
		}];
		await browser.close();
		req.session.url = res_data;
		res.send(res_data);
	}

}); // global function closing


// Scrape urls to grafana dashboard by automatically logging in to dashboard
router.get('/graf_url/:ip', async(req, res) => {
	let url = `http://${req.params.ip}:3000/login`,
		res_data;
	const browser = await puppeteer.launch({
		headless: false,
		args: ['--ignore-certificate-errors --enable-features=NetworkService', '--no-sandbox', '--disable-setuid-sandbox']
	});
	const page = await browser.newPage();
	const client = await page.target().createCDPSession();
	await client.send('Security.setIgnoreCertificateErrors', {
		ignore: true
	});

	await page.setViewport({
		width: 1450,
		height: 750
	})

	try {
		res_data = [{
			"type": "success"
		}];
		//  Type in the username and password
		// const navigationPromise = page.waitForNavigation()
		await page.goto(url, {
			waitUntil: 'networkidle0'
		}); // wait until page load   
		// await page.waitForNavigation({ waitUntil: 'networkidle0' });
		await page.type('input[name="username"]', "admin");
		await page.type('input[name="password"]', "admin");
		await page.click('button[type="submit"]');

		await page.waitForNavigation({
			waitUntil: 'networkidle0'
		});
		await page.waitFor(20);


		//Configure data source
		await page.waitForSelector('.hide-controls > dashnav > .navbar > .navbar-inner > .navbar-brand-btn')
		await page.waitFor(20);
		await page.click('.hide-controls > dashnav > .navbar > .navbar-inner > .navbar-brand-btn')

		await page.waitForSelector('sidemenu > .sidemenu > .dropdown:nth-child(4) > .sidemenu-item > .sidemenu-item-text')
		await page.waitFor(20);
		await page.click('sidemenu > .sidemenu > .dropdown:nth-child(4) > .sidemenu-item > .sidemenu-item-text')

		await page.waitForSelector('.card-item-wrapper > .card-item > .card-item-body > .card-item-details > .card-item-name')
		await page.waitFor(20);
		await page.click('.card-item-wrapper > .card-item > .card-item-body > .card-item-details > .card-item-name')


		await page.waitForSelector('.gf-form-group > .gf-form-group > .gf-form-inline > .gf-form > .gf-form-input')
		await page.waitFor(20);


		await page.evaluate(function () {
			document.querySelector('input[ng-model="current.url"]').value = ''
		})
		await page.type('input[ng-model="current.url"]', "http://192.168.10.5:8086");


		await page.waitFor(20);


		await page.evaluate(function () {
			document.querySelector('input[ng-model="ctrl.current.user"]').value = ''
		})
		await page.type('input[ng-model="ctrl.current.user"]', "lrdata");


		await page.waitFor(20);


		await page.evaluate(function () {
			document.querySelector('input[ng-model="ctrl.current.password"]').value = ''
		})

		await page.type('input[ng-model="ctrl.current.password"]', "test");

		await page.waitForSelector('.page-container > .tab-content > .ng-pristine > .gf-form-button-row > .width-8')
		await page.waitFor(20);
		await page.click('.page-container > .tab-content > .ng-pristine > .gf-form-button-row > .width-8')


		//Go to dashboard 

		await page.waitForSelector('.grafana-app > .main-view > .navbar > .navbar-inner > .navbar-brand-btn')
		await page.waitFor(20);
		await page.click('.grafana-app > .main-view > .navbar > .navbar-inner > .navbar-brand-btn')

		await page.waitForSelector('sidemenu > .sidemenu > .dropdown:nth-child(2) > .sidemenu-item > .sidemenu-item-text')
		await page.waitFor(20);
		await page.click('sidemenu > .sidemenu > .dropdown:nth-child(2) > .sidemenu-item > .sidemenu-item-text')


		await page.waitForSelector('dashnav > .navbar > .navbar-inner > .navbar-section-wrapper > .navbar-page-btn')
		await page.waitFor(300);
		await page.click('dashnav > .navbar > .navbar-inner > .navbar-section-wrapper > .navbar-page-btn')

		await page.waitForSelector('.search-dropdown > .search-results-container > .search-item-dash-json > .search-result-link > span')
		await page.waitFor(500);
		await page.click('.search-dropdown > .search-results-container > .search-item-dash-json > .search-result-link > span')

		await page.waitForSelector('.navbar-inner > .nav > .dropdown > .pointer > .fa-share-square-o')
		await page.waitFor(500);
		await page.click('.navbar-inner > .nav > .dropdown > .pointer > .fa-share-square-o')

		await page.waitForSelector('.dropdown > .dropdown-menu > li:nth-child(1) > .pointer > .dropdown-desc')
		await page.waitFor(500);
		await page.click('.dropdown > .dropdown-menu > li:nth-child(1) > .pointer > .dropdown-desc')


		await page.waitForSelector('div > .gf-form-group > .gf-form-inline > .gf-form > .gf-form-input')
		await page.waitFor(500);
		var element = await page.$('div > .gf-form-group > .gf-form-inline > .gf-form > .gf-form-input');
		const screen_link = await page.evaluate(element => element.value, element)

		await browser.close();
		res.send(screen_link);
	} catch (err) {

		console.log("PPTR Error - handled case", err);
		res_data = [{
			"type": "error"
		}];
		await browser.close();
		// req.session.url = res_data;
		res.send(res_data);
	}

});


// Connect to user input collection from mongo database
async function loadUserInputCollection() {
	const client = await mongodb.MongoClient.connect(
		'mongodb+srv://xin:xry112358@cluster0.utjhm.mongodb.net/test?retryWrites=true&w=majority', {
			useNewUrlParser: true
		}, {
			useUnifiedTopology: true
		});
	return client.db('blockchain_tool').collection('user_input');
}


//########################################## 
//Transaction database
//##########################################


// Get transactions from database
router.get('/transactions', async(req, res) => {
	const transactions = await loadTransactionCollection();
	res.send(await transactions.find({}).toArray());
});


// Add transaction to database
router.post('/insert_transaction', async(req, res) => {
	const user_input = await loadTransactionCollection();
	await user_input.insertOne({
		timestamp: new Date(),
		transaction: req.body.transaction,
	});
	res.status(201).send();
});


// Send transaction to blockchain
router.get('/send_trans/:id/:trans_id', async(req, res) => {
	const user_input = await loadTransactionCollection();
	const transaction = await user_input.findOne({
		_id: new mongodb.ObjectID(req.params.trans_id)
	});
	const obj = JSON.stringify(transaction);
	fs.writeFileSync('./server/json_files/transaction.json', obj);

	execute(`sudo ./cloud_storm/scripts/send_transaction.sh "./server/json_files/transaction.json" ${req.params.id}`)

	req.session.trans_id = req.params.trans_id

	res.status(201).send();

});


// Delete transactions from database
router.delete('/transactions', async(req, res) => {
	try {
		const transactions = await loadTransactionCollection();
		await transactions.remove({});
		res.status(200).send();
	} catch (err) {
		next(err);
	}
});


// Connect to transaction collection from mongo database
async function loadTransactionCollection() {
	const client = await mongodb.MongoClient.connect(
		'mongodb+srv://xin:xry112358@cluster0.utjhm.mongodb.net/test?retryWrites=true&w=majority', {
			useNewUrlParser: true
		}, {
			useUnifiedTopology: true
		});
	return client.db('blockchain_tool').collection('transactions');
}


module.exports = router;