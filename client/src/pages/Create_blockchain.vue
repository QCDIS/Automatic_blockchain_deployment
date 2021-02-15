<template>
    
<div>
   <div class="card" id="user_input">
      <p class="error" v-if="error">{{ error }} </p>
      <div class="card-body">
         <h2 class="card-title">{{heading}} </h2>
         <br/>
         <div class="create_user_input">
            <!-- Specify blockchain type -->
            <label for="create_user_input">Blockchain type</label>
            <select class="form-control" name="create_user_input" id="create_user_input" v-model="input.blockchain_type" placeholder="Blockchain type">
               <option v-for="option in select_options.blockchain_type_options">{{option.text}} </option>
            </select>
            <br/>
            <!-- Specify consensus algorithm -->
            <label for="create_user_input">Consensus algorithm</label>
            <select class="form-control" v-model="input.consensus_algorithm" placeholder="consensus algorithm">
               <option>PoET</option>
               <option>pBFT</option>
               <option>raft</option>
            </select>
            <br/>
            <br/>
            <!-- Host configuration -->
            <h2 class="card-title">Hosts configuration </h2>
            <br/>
            <!-- #############################################################
               Random host form
               ############################################################ -->
            <base-button class="btn-sm" v-on:click="random_hidden = !random_hidden">Random blockchain nodes &nbsp; &nbsp; <i class="tim-icons icon-minimal-down">  </i> </base-button>
            <!-- <base-button class="btn-success btn-simple btn-sm" v-on:click="random_hidden = !random_hidden">Random blockchain nodes &nbsp; &nbsp; <i class="tim-icons icon-minimal-down">  </i> </base-button> -->
            <br/>
            <br/>
            <div id="create_blockchain"  v-if="!random_hidden">
               <label>Cloud environment</label>
               <select class="form-control" name="cloud" id="cloud" v-model="random_host" placeholder="Cloud environment">
                  <option v-for="option in select_options.cloud_options" v-bind:value="option.text">{{option.text}} </option>
               </select>
               <br/> 
               <label>Amount of instances</label>
               <input type="number" class="form-control" v-model.number="nr_random_hosts">    
               <br/>
               <base-button class="btn-success btn-simple btn-round btn-sm" v-on:click="add_random_hosts(nr_random_hosts)">Confirm amount  &nbsp; <i class="tim-icons icon-simple-add"> </i> </base-button>
               <br/>
               <br/>
            </div>
            <br/>
            <!-- #############################################################
               Specific host form
               ############################################################ -->
            <base-button class="btn-sm" v-on:click="add_host(); specific_hidden = !specific_hidden">Specific blockchain nodes  &nbsp;  &nbsp; <i class="tim-icons icon-minimal-down"> </i> </base-button>
            <!-- <base-button class="btn-success btn-simple btn-sm" v-on:click="add_host(); specific_hidden = !specific_hidden">Specific blockchain nodes  &nbsp;  &nbsp; <i class="tim-icons icon-minimal-down"> </i> </base-button> -->
            <div id="create_blockchain" v-for="(host, index) in input.hosts" v-if="!specific_hidden">
               <br/>
               <h4 class="card-title">Instance type {{index + 1}} </h4>
               <label>Cloud environment</label>
               <select class="form-control" name="cloud" id="cloud" v-model="host.cloud" placeholder="Cloud environment">
                  <option v-for="option in select_options.cloud_options" v-bind:value="option.text">{{option.text}} </option>
               </select>
               <br/>
               <label>Amount of instances</label>
               <input type="number" class="form-control" v-model.number="host.number">
               <br/>
               <!-- zone dependent on cloud environment-->
               <label>Zone</label>
               <select class="form-control" name="zone" id="zone" v-model="host.zone" placeholder="Zone">
                  <option v-for="option in select_options.zone_options[host.cloud]" v-bind:value="option.text">{{option.text}} </option>
               </select>
               <br/>
               <!-- operating system dependent on chosen zone-->
               <div v-if="host.cloud === 'ExoGENI'">
                  <label>Operating system</label>
                  <select class="form-control" name="os_type" id="os_type" v-model="host.os_type" placeholder="Operating system">
                     <option v-for="option in select_options.os_type_options.ExoGENI[host.zone]" v-bind:value="option.text">{{option.text}} </option>
                  </select>
               </div>
               <div v-if="host.cloud === 'EC2'">
                  <label>Operating system</label>
                  <select class="form-control" name="os_type" id="os_type" v-model="host.os_type" placeholder="Operating system">
                     <option v-for="option in select_options.os_type_options.EC2" v-bind:value="option.text">{{option.text}} </option>
                  </select>
               </div>
               <div v-else-if="host.cloud === 'EGI'">
                  <label>Operating system</label>
                  <select class="form-control" name="os_type" id="os_type" v-model="host.os_type" placeholder="Operating system">
                     <option v-for="option in select_options.os_type_options.EGI" v-bind:value="option.text">{{option.text}} </option>
                  </select>
               </div>
               <br/>
               <!-- instance type dependent on cloudprovider and chosen zone-->
               <div v-if="host.cloud === 'ExoGENI'">
                  <div>
                     <label>Instance type</label>
                     <select class="form-control" name="instance_type" id="instance_type" v-model="host.instance_type" placeholder="Instance type">
                        <option v-for="option in select_options.instance_type_options.ExoGENI[host.zone]" v-bind:value="option.text">{{option.text}} </option>
                     </select>
                  </div>
               </div>
               <div v-else-if="host.cloud === 'EC2'">
                  <label>Instance type</label>
                  <select class="form-control" name="instance_type" id="instance_type" v-model="host.instance_type" placeholder="Instance type">
                     <option v-for="option in select_options.instance_type_options.EC2" v-bind:value="option.text">{{option.text}} </option>
                  </select>
               </div>
               <div v-else-if="host.cloud === 'EGI'">
                  <label>Instance type</label>
                  <select class="form-control" name="instance_type" id="instance_type" v-model="host.instance_type" placeholder="Instance type">
                     <option v-for="option in select_options.instance_type_options.EGI" v-bind:value="option.text">{{option.text}} </option>
                  </select>
               </div>
            </div>
            <br/>
            <base-button v-if="!specific_hidden" @click="add_host">Add more instances</base-button>
         </div>
      </div>
      <base-button type="success btn-simple" v-on:click="create_input(); notifyVue('top', 'center')" fill>Create blockchain</base-button>
      <base-button type="success btn-simple" v-on:click="next_page()" fill>Go to blockchain overview</base-button>
   </div>
</div>

</template>



<script>
import user_input_service from '../user_input_service';
const ExoGENI_zone_array = require('../dependent_dropdown').ExoGENI_zone_array;

import NotificationTemplate from './Notifications/NotificationTemplate';
import {
	BaseAlert
} from '@/components';

const EC2_zone_array = require('../dependent_dropdown').EC2_zone_array;
const EGI_zone_array = require('../dependent_dropdown').EGI_zone_array;


const EXO_os_type_options = require('../dependent_dropdown').ExoGENI_os_type_obj;
const EXO_instance_type_options = require('../dependent_dropdown').ExoGENI_instance_type_obj;


export default {
	name: "user_input",
	components: {
		user_input_service,
		BaseAlert
	},
	data() {
		return {
			heading: 'Blockchain configuration',

			type: ["", "info", "success", "warning", "danger"],
			notifications: {
				topCenter: false
			},
			random_hidden: true,
			specific_hidden: true,

			random_host: '',
			nr_random_hosts: '',

			all_inputs: [],
			error: '',

			select_options: {
				blockchain_type_options: [{
					text: "Sawtooth"
				}, ],
				cloud_options: [{
						text: "ExoGENI"
					},
					{
						text: "EC2"
					},

				],
				zone_options: {
					"ExoGENI": ExoGENI_zone_array,
					"EC2": EC2_zone_array,
				},
				os_type_options: {
					"ExoGENI": EXO_os_type_options,
					"EC2": [{
						text: "Ubuntu 16.04"
					}],
				},
				instance_type_options: {
					"ExoGENI": EXO_instance_type_options,
					"EC2": [{
							text: "t2.nano"
						},
						{
							text: "t2.micro"
						},
						{
							text: "t2.medium"
						}
					]
				},
				EXO_os_type_options,
				EXO_instance_type_options,

			},

			input: {
				blockchain_type: '',
				consensus_algorithm: '',
				hosts: [],
				transactions: []
			},
		}
	},
	computed: {
		next_page() {
			this.$router.push({
				name: 'Blockchain overview'
			});
		}
	},
	methods: {
		goBack() {
			window.history.length > 1 ? this.$router.go(-1) : this.$router.push('/');
		},
		// Function for notification
		notifyVue(verticalAlign, horizontalAlign) {
			const color = Math.floor(Math.random() * 4 + 1);
			this.$notify({
				component: NotificationTemplate,
				icon: "tim-icons icon-bell-55",
				horizontalAlign: horizontalAlign,
				verticalAlign: verticalAlign,
				type: this.type[color],
				timeout: 0
			});
		},
		random_nr(max) {
			return Math.floor(Math.random() * Math.floor(max));

		},
		add_host() {
			this.input.hosts.push({

				cloud: '',
				number: '',
				zone: '',
				os_type: '',
				instance_type: ''
			})

		},

		// Add random host
		add_random_hosts(nr) {
			for (i = 0; i < nr; i++) {
				var random_cloud = this.random_host
				if (random_cloud == "ExoGENI") {
					var zone_arr = this.select_options.zone_options[random_cloud];
					var random_zone = zone_arr[this.random_nr(zone_arr.length)].text;
					var os_arr = this.select_options.os_type_options.ExoGENI[random_zone];
					var random_os = os_arr[this.random_nr(os_arr.length)].text;
					var instance_arr = this.select_options.instance_type_options.ExoGENI[random_zone];
					var random_instance = instance_arr[this.random_nr(instance_arr.length)].text;

				} else {
					var zone_arr = this.select_options.zone_options[random_cloud];
					var random_zone = zone_arr[this.random_nr(zone_arr.length)].text;
					var os_arr = this.select_options.os_type_options[random_cloud];
					var random_os = os_arr[this.random_nr(os_arr.length)].text;
					var instance_arr = this.select_options.instance_type_options[random_cloud];
					var random_instance = instance_arr[this.random_nr(instance_arr.length)].text;

				}

				var hosts_arr = this.input.hosts;
                var hosts_arr2 = this.input.hosts[0];

				this.input.hosts.push({
					cloud: random_cloud,
					number: 1,
					zone: random_zone,
					os_type: random_os,
					instance_type: random_instance
				})


			}
		},
		log(msg) {
			console.log(msg);
		},
		// Create blockchain
		async create_input() {
			// Insert input in database
			await user_input_service.insert_user_input(this.input);
			// Retrieve all inputs
			this.all_inputs = await user_input_service.get_all_inputs();
			const obj = JSON.parse(JSON.stringify(this.all_inputs));
			// Get last inserted input
			var length = obj.length - 1
			// Create blockchain via middleware and server
			await user_input_service.create_blockchain(obj[length]._id);
		},

		async delete_input(id) {
			await user_input_service.delete_user_input(id);
			this.all_inputs = await user_input_service.get_all_inputs();
		},
		// Retrieve blockchain configuration by id
		async get_by_id(id) {
			retrieved_input = await user_input_service.get_input_by_id(id);
		},
	}
}

</script>



