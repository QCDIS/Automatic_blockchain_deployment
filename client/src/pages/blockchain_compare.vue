

<template>

<div>
   <div class="text-center">
      <base-button type="success btn-simple" v-on:click="create_table();" fill>Click to retrieve blockchains &nbsp;  &nbsp; <i class="tim-icons icon-minimal-down"> </i> </base-button>
   </div>
   <br/>
   <br/>
   <div class="card" id="user_input">
      <div class="row">
         <div class="col-12">
            <card type="tasks" >
               <template slot="header">
                  <h1 class="card-title">Compare performance </h1>
                  <p class="card-category d-inline">{{'Overview'}}</p>
               </template>
               <div class="table-full-width table-responsive">
                  <base-table :data="this.blockList"
                     thead-classes="text-primary">
                     <template slot-scope="{row}">
                        <td>
                           <base-checkbox v-model="row.checked">
                           </base-checkbox>
                        </td>
                        <td>
                           <p class="title">{{row.detail.title}}</p>
                           <p class="text-muted">{{row.detail.description}}</p>
                        </td>
                        <td class="td-actions text-right">
                           <base-button type="link" aria-label="edit button" v-on:click="delete_blockchain(row.detail.id, row)">
                              <i class="tim-icons icon-simple-remove"></i>
                           </base-button>
                        </td>
                     </template>
                  </base-table>
               </div>
            </card>
         </div>
      </div>
      <base-button type="success btn-simple" v-on:click="compare()" fill>Compare blockchain performances</base-button>
      <br/>
      <div id="graf_frame">
      </div>
   </div>
</div>

</template>


<script>

   import UserTable from './Dashboard/UserTable';
import {
	BaseTable
} from '@/components'
import user_input_service from '../user_input_service';

export default {
	components: {

		UserTable,
		BaseTable,
		user_input_service,

	},
	data() {
		return {
			all_inputs: [],
			checked_id: [],
			initial_length: '',
			updated_length: '',
			blockList: [

			],
			monitor1: "145.100.133.242",
			monitor2: "145.100.133.205",
			monitor_ip: '',
			graf_url: '',
			metric_links: [],
			metric_urls_checked: []
		}
	},

	methods: {
		async retrieve_links(id) {
			var blockchain = await this.get_by_id(id)
			// var monitor_ip = await this.get_pub_ip_by_id(id)
			var monitor_ip = await this.get_pub_ip_by_id(id)
			await this.get_graf_url_by_id(id, monitor_ip)
		},
		async get_input() {
			this.all_inputs = await user_input_service.get_all_inputs();
		},
		async get_by_id(id) {
			var retrieved_input = await user_input_service.get_by_id(id);
			return retrieved_input
		},

		create_table() {

			for (i = 0; i < this.all_inputs.length; i++) {
				var id = this.all_inputs[i]._id
				this.blockList[i].detail.title = `id: ${id}`
				this.blockList[i].detail.id = id
				this.blockList[i].index = i
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
				// console.log(i)
				link = link.replace("panelId=1", `panelId=${i}`)
				// console.log(link)
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
				console.log(blockchain)
				if (!blockchain.metric_urls) {
					if (!blockchain.monitor_ip) {
						await this.retrieve_links(id)
					}
					var blockchain = await this.get_by_id(id)
					var monitor_ip = await blockchain.monitor_ip
					var metric_url = await user_input_service.get_metric_url(monitor_ip);
					var metric_urls = this.genenerate_metric_urls(metric_url)
					await user_input_service.update_input_with_metric_urls(metric_urls, id)
					var blockchain = await this.get_by_id(id)
				}

				metric_urls_checked.push(blockchain.metric_urls)
			}

			this.metric_urls_checked = metric_urls_checked
			return metric_urls_checked
		},


		async display_metrics(metric_urls) {
			if (metric_urls.length == 2) {
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

				for (var i = 20; i < (metric_links1.length); i++) {
					var iframe_url1 = metric_links1[i]
					var iframe_url2 = metric_links2[i]
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="50%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe> <br/>'
				}

			}


			if (metric_urls.length == 3) {
				var metric_links1 = metric_urls[0]
				var metric_links2 = metric_urls[1]
				var metric_links3 = metric_urls[2]
				for (var i = 0; i < 4; i++) {
					var iframe_url1 = metric_links1[i]
					var iframe_url2 = metric_links2[i]
					var iframe_url3 = metric_links3[i]
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url3 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff9900;"></iframe>'
				}

				for (var i = 4; i < 10; i++) {
					var iframe_url1 = metric_links1[i]
					var iframe_url2 = metric_links2[i]
					var iframe_url3 = metric_links3[i]
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url3 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff9900;"></iframe>'

				}

				for (var i = 10; i < 20; i++) {
					var iframe_url1 = metric_links1[i]
					var iframe_url2 = metric_links2[i]
					var iframe_url3 = metric_links3[i]
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url3 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff9900;"></iframe>'
				}

				for (var i = 20; i < (metric_links1.length); i++) {
					var iframe_url1 = metric_links1[i]
					var iframe_url2 = metric_links2[i]
					var iframe_url3 = metric_links3[i]
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url1 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #66ffcc;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url2 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff00ff;"></iframe>'
					document.getElementById('graf_frame').innerHTML += '<iframe src="' + iframe_url3 + '" width="30%" height="400" frameborder="10" style="border: 1px solid #ff9900;"></iframe>'
				}

			}
		},


		async compare() {
			var metric_urls_checked = await this.load_metrics();
			console.log(metric_urls_checked)
			await this.display_metrics(metric_urls_checked);

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
			console.log(row.index)
			console.log(new_index)
			this.blockList.splice((new_index), 1)
			this.updated_length = this.blockList.length
		}


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

