/**
 * File name: user_input_service.js
 * Middleware to post server requests and retrieve data.
 */


import axios from 'axios';

const url = 'api/user_input/';


class user_input_service {
	// Server request to retrieve all user inputs
	static get_all_inputs() {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(url);
				const data = res.data;
				resolve(
					data.map(user_input => ({
						...user_input
					}))
				);
			} catch (err) {
				reject(err);

			}
		});
	}

    // Server request to retrieve a user input by id
	static get_by_id(id) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}get_by_id/${id}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});

	}


    // Server request to retrieve url to individual grafana graph
	static get_metric_url(ip) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}metric_url/${ip}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});

	}

    
    // Server request to retrieve url to grafana dashboard
	static get_grafana_url_by_ip(ip) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}graf_url/${ip}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});

	}


    // Server request to get public ip from monitor by id
	static get_pub_ip_by_id(id) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}get_pub_ip_by_id/${id}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});

	}


    // Server request to run architecture with cloudsStorm
	static create_blockchain(id) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}create_blockchain/${id}`);
				const monitor_pub_ip = res.data;
				resolve(monitor_pub_ip);
			} catch (err) {
				reject(err);

			}
		});
	}

	// Update user input with public ip of monitor
	static add_monitor_ip(id, monitor_ip) {
		return axios.patch(`${url}add_monitor_ip/${id}`, {
			monitor_ip: monitor_ip
        });
	}

	// Update user input with url to dashboard
	static add_graf_url(id, graf_url) {
		return axios.patch(`${url}add_graf_url/${id}`, {
			graf_url: graf_url
		});
	}



	// Update user input with url to individual metrics
	static update_input_with_metric_urls(metric_urls, id) {
		return axios.patch(`${url}update_input_with_metric_urls/${id}`, {
			metric_urls: metric_urls
		});
	}

	// Update user input with transaction
	static update_input_with_trans(trans_id) {
		return axios.patch(`${url}update_input_with_trans`, {
			trans_id: trans_id
		});
	}


	// Create user input
	static insert_user_input(input) {
		return axios.post(url, {
			input: input
		});
	}


	// Delete blockchain
	static delete_blockchain(id) {
        return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}delete_blockchain/${id}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});
	}

	// Delete user input
	static delete_user_input(id) {
        return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.delete(`${url}delete/${id}`);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});
	}        

	// Delete all user inputs
	static delete_all(id) {
        return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.delete(url);
				const data2 = res.data;
				resolve(data2);
			} catch (err) {
				reject(err);

			}
		});
	}


	/////////////////////////////////////
	//Transactions
    ////////////////////////////////////
    
    // Retrieve all transaction
	static get_all_trans() {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}transactions`);
				const data = res.data;
				resolve(
					data.map(transactions => ({
						...transactions
					}))
				);
			} catch (err) {
				reject(err);

			}
		});
	}

    // Insert transaction
	static insert_transaction(transaction) {
		return axios.post(`${url}insert_transaction`, {
			transaction: transaction
		});
	}

    // Send transaction to blockchain
	static send_transaction_by_id(id, trans_id) {
		return new Promise(async(resolve, reject) => {
			try {
				const res = await axios.get(`${url}send_trans/${id}/${trans_id}`);
				const trans = res.data;
				resolve(trans);
			} catch (err) {
				reject(err);

			}
		});
	}


	// Delete all user inputs
	static delete_all_trans(id) {
		return axios.delete(`${url}transactions`);
	}


}

export default user_input_service;