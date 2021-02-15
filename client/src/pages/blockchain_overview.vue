

<template>


<div>
   <!-- Profile performance -->
   <div class="card" id="user_input" v-if="!graf_hidden">
      <div class="card-body">
         <div class="text-right">
            <base-button type="link btn-success" aria-label="edit button" v-on:click="graf_hidden=!graf_hidden">
               <i class="tim-icons icon-simple-remove"></i>
            </base-button>
         </div>
         <div id="graf_frame">
         </div>
      </div>
   </div>
   <!-- Send transactions -->
   <div v-if="!trans_hidden">
      <div class="card" id="user_input">
         <div class="card-body">
            <div class="text-right">
               <base-button type="link btn-success" aria-label="edit button" v-on:click="trans_hidden=!trans_hidden">
                  <i class="tim-icons icon-simple-remove"></i>
               </base-button>
            </div>
            <h2 class="card-title">Send transactions </h2>
            <br/>
            <br/>
            <h4>Execution time</h4>
            <div> {{transaction.execution_time}}</div>
            <input type="range" class="form-control-range" id="formControlRange" v-model="transaction.execution_time" min="5" max="800" step="5" start="10">
            <br/>
            <br/>
            <h4>Input rate</h4>
            <div> {{transaction.input_rate}}</div>
            <input type="range" class="form-control-range" id="formControlRange" v-model="transaction.input_rate" min="5" max="60" start="10">
            <br/>
            <br/>
            <br/>
         </div>
         <base-button type="success btn-simple" v-on:click="send_transaction_request()">Send transaction</base-button>
         <base-button type="success btn-simple" v-on:click="view_performance(send_trans_to); notifyVue('top', 'center'); hidden = !hidden; graf_hidden = !graf_hidden">View performance</base-button>
      </div>
      <br/>
      <br/>
      <br/>
   </div>
   <div class="text-center">
      <br/>
      <br/>
      <br/>
      <base-button type="success btn-simple" v-on:click="create_list(); hidden = !hidden" fill>Click to retrieve blockchains &nbsp;  &nbsp; <i class="tim-icons icon-minimal-down">  </i> </base-button>
   </div>
   <br/>
   <br/>
   <br/>
   <div class="row" v-if="!hidden">
      <div class="col-md-12" v-for="blockchain in this.blockList">
         <card class="btn-simple">
            <div class="text-right">
               <base-button type="link btn-success" aria-label="edit button" v-on:click="delete_blockchain(blockchain.detail.id, blockchain)">
                  <i class="tim-icons icon-simple-remove"></i>
               </base-button>
            </div>
            <h2 class="card-title">{{blockchain.detail.title}} </h2>
            {{blockchain.detail.description}}
            <br/>
            <br/>
            <base-button v-on:click="view_performance(blockchain.detail.id); notifyVue('top', 'center'); hidden = !hidden; graf_hidden = !graf_hidden" fill>View performance </base-button>
            &nbsp;
            <base-button v-on:click="send_trans_to = blockchain.detail.id; trans_hidden = !trans_hidden; hidden = !hidden" fill>Send transaction request  </base-button>
            <br/>
            <br/>
         </card>
         <br/>
      </div>
   </div>
   <br/>
</div>
</div>


</template>


<script>

import UserTable from './Dashboard/UserTable';
import {
	BaseTable
} from '@/components'
import user_input_service from '../user_input_service';


import login_notification from './Notifications/login_notification';
import {
	BaseAlert
} from '@/components';

export default {
	components: {

		BaseAlert,
		UserTable,
		BaseTable,
		user_input_service,

	},
	data() {
		return {
			type: ["", "info", "success", "warning", "danger"],
			notifications: {
				topCenter: false
			},
			hidden: true,
			trans_hidden: true,
			graf_hidden: true,
			all_inputs: [],
			all_trans: [],
			nr_random_hosts: '',
			send_trans_to: '',
			transaction: {
				trans_id: '',
				execution_time: '410',
				input_rate: '33'
			},
			multiple_trans: [],
			checked_id: [],
			initial_length: '',
			updated_length: '',
			blockList: [

			],
			monitor_ip: '',
			graf_url: '',
			metric_links: []
		}
	},

	methods: {
		async send_transaction_request() {
			var trans_to = this.send_trans_to
			var blockchain = await this.get_by_id(trans_to)
			if (!blockchain.monitor_ip) {
				await this.retrieve_links(trans_to)
			}
			await user_input_service.insert_transaction(this.transaction);
			this.all_trans = await user_input_service.get_all_trans();
			const obj2 = JSON.parse(JSON.stringify(this.all_trans));
			var length = obj2.length - 1
			var transaction_id = obj2[length]._id
			await user_input_service.send_transaction_by_id(trans_to, transaction_id);
		},
		get_slider_value(slider) {
			console.log(slider.noUiSlider.get())
			return slider.noUiSlider.get();
		},
		async retrieve_links(id) {
			var blockchain = await this.get_by_id(id)
			if (!blockchain.monitor_ip) {
				var monitor_ip = await this.get_pub_ip_by_id(id)
			} else {
				var monitor_ip = blockchain.monitor_ip
			}
			if (!blockchain.graf_url) {
				await this.get_graf_url_by_id(id, monitor_ip)
			}
		},

		async view_performance(id) {
			var blockchain = await this.get_by_id(id)
			await this.retrieve_links(id)
			var blockchain = await this.get_by_id(id)
			// if (!blockchain.monitor_ip) {
			//     await this.retrieve_links(id)
			//     var blockchain = await this.get_by_id(id)
			// }
			console.log(blockchain.graf_url)
			console.log(blockchain.monitor_ip)
			var iframe_url = await blockchain.graf_url
			document.getElementById('graf_frame').innerHTML = '<iframe src="' + iframe_url + '" width="1450" height="1000" frameborder="0" ></iframe>'

		},
		async get_pub_ip_by_id(id) {
			var monitor_ip = await user_input_service.get_pub_ip_by_id(id)
			await user_input_service.add_monitor_ip(id, monitor_ip)
			this.monitor_ip = monitor_ip
			return monitor_ip
		},
		async get_graf_url_by_id(id, monitor_ip) {
			var graf_url = await user_input_service.get_grafana_url_by_ip(monitor_ip);
			await user_input_service.add_graf_url(id, graf_url);
			this.graf_url = graf_url

		},
		async get_input() {
			this.all_inputs = await user_input_service.get_all_inputs();
		},
		async get_by_id(id) {
			var retrieved_input = await user_input_service.get_by_id(id);
			return retrieved_input
		},

		create_list() {

			for (i = 0; i < this.all_inputs.length; i++) {
				var id = this.all_inputs[i]._id
				this.blockList[i].detail.title = `Blockchain id: ${id}`
				this.blockList[i].detail.id = id
				this.blockList[i].index = i
				var timestamp = this.all_inputs[i].timestamp
				var type = this.all_inputs[i].input.blockchain_type
				var cons = this.all_inputs[i].input.consensus_algorithm
				var cloud = this.all_inputs[i].input.hosts[0].cloud
				var os = this.all_inputs[i].input.hosts[0].os_type
				var instance_type = this.all_inputs[i].input.hosts[0].instance_type
				var number = this.all_inputs[i].input.hosts[0].number
				var zone = this.all_inputs[i].input.hosts[0].zone
				this.blockList[i].detail.description = `${cons} - ${cloud} - ${number} nodes - ${instance_type} - ${type} - ${os} - ${zone}`
				this.blockList[i].checked = false

				if (i !== (this.all_inputs.length - 1)) {
					this.add_block()
				}

			}
			this.initial_length = this.blockList.length
			this.updated_length = this.blockList.length

		},
		add_block() {
			this.blockList.push({
				checked: false,
				index: '',
				detail: {
					id: '',
					title: '',
					description: '',
				}
			})

		},
		get_checked() {
			for (i = 0; i < this.blockList.length; i++) {
				if (this.blockList[i].checked) {
					this.checked_id.push(this.blockList[i].detail.id)
				}
			}
			return this.checked_id

		},
		genenerate_metric_urls(metric_url) {
			console.log(metric_url)
			var metric_urls = []
			for (i = 1; i < 46; i++) {
				var link = `${metric_url}`
				link.replace("panelId=1", `panelId=${i}`)
				metric_urls.push(link)
			}
			this.metric_links = metric_url
			return metric_urls

		},

		async load_metrics() {
			var checked = this.get_checked()
			var metric_urls_checked = []
			for (var i = 0; i < (checked.length); i++) {
				var id = checked[i]
				var blockchain = await this.get_by_id(id)
				if (!blockchain.monitor_ip) {
					await this.retrieve_links(id)
					var blockchain = await this.get_by_id(id)

				} else {
					var monitor_ip = await blockchain.monitor_ip
				}
				var metric_url = await user_input_service.get_metric_url(monitor_ip);
				var metric_urls = this.genenerate_metric_urls(metric_url)
				metric_urls_checked.push([metric_urls])
				await user_input_service.update_input_with_metric_urls(metric_urls, id)
			}


			return metric_urls_checked
		},


		async display_metrics(metric_urls) {
			var metric_links1 = metric_urls[0]
			var metric_links2 = metric_urls[1]
			for (var i = 0; i < 4; i++) {
				var iframe_url1 = metric_links1[i]
				var iframe_url2 = metric_links2[i]
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe> <br/>'
			}

			for (var i = 4; i < 10; i++) {
				var iframe_url1 = metric_links1[i]
				var iframe_url2 = metric_links2[i]
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe> <br/>'
			}

			for (var i = 10; i < 20; i++) {
				var iframe_url1 = metric_links1[i]
				var iframe_url2 = metric_links2[i]
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe> <br/>'
			}

			for (var i = 20; i < (metric_links.length); i++) {
				var iframe_url1 = metric_links1[i]
				var iframe_url2 = metric_links2[i]
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
				document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe> <br/>'
			}
		},


		async compare() {
			var metric_urls_checked = await this.load_metrics();
			console.log(metric_urls_checked)
			await this.display_metrics(metric_urls_checked);

		},


		async get_by_id(id) {
			var retrieved_input = await user_input_service.get_by_id(id);
			return retrieved_input
		},

		async delete_blockchain(id, row) {
			var difference = this.initial_length - this.updated_length
			var index = row.index
			var new_index = index - difference
			await user_input_service.delete_blockchain(id);
			await user_input_service.delete_user_input(id);
			this.blockList.splice((new_index), 1)
			this.updated_length = this.blockList.length
		},

		notifyVue(verticalAlign, horizontalAlign) {
			const color = Math.floor(Math.random() * 4 + 1);
			this.$notify({
				component: login_notification,
				icon: "tim-icons icon-bell-55",
				horizontalAlign: horizontalAlign,
				verticalAlign: verticalAlign,
				type: this.type[color],
				timeout: 0
			});
		},


	},
	mounted: function () {
		this.get_input()
		this.add_block()

	},
	computed: {
		next_page() {
			this.$router.push({
				name: 'Compare performance'
			});
		}
	},

}
</script>

