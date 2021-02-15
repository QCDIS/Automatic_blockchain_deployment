
<template>

<div class="row">
   <div class="col-12">
      <div class="text-center">
         <base-button type="success btn-simple" v-on:click="create_table(); specific_hidden = !specific_hidden" fill>Click to retrieve transactions &nbsp;  &nbsp; <i class="tim-icons icon-minimal-down"> </i> </base-button>
      </div>
      <br/>
      <br/>
      <card :title="table1.title">
         <div class="table-responsive">
            <div v-if="!specific_hidden">
               <base-table :data="table1.data"
                  :columns="table1.columns"
                  thead-classes="text-primary">
               </base-table>
            </div>
         </div>
      </card>
   </div>
</div>
    

</template>

<script>
import user_input_service from '../user_input_service';

import {
	BaseTable
} from "@/components";
const tableColumns = ["timestamp", "transaction", "executiontime", "inputrate"];

export default {
	name: "user_input",
	components: {
		user_input_service,
		BaseTable
	},
	data() {
		return {
			all_inputs: [],
			all_trans: [],
			specific_hidden: true,
			error: '',
			table1: {
				title: "Transaction requests",
				columns: [...tableColumns],
				data: []
			}
		}
	},
	methods: {
		async get_input() {
			this.all_inputs = await user_input_service.get_all_inputs();
		},
		async get_transactions() {
			this.all_trans = await user_input_service.get_all_trans();
		},
		create_table() {
			for (i = 0; i < this.all_trans.length; i++) {
				this.table1.data[i].timestamp = this.all_trans[i].timestamp
				this.table1.data[i].transaction = this.all_trans[i]._id
				this.table1.data[i].executiontime = this.all_trans[i].transaction.execution_time
				this.table1.data[i].inputrate = this.all_trans[i].transaction.input_rate

				if (i !== (this.all_inputs.length - 1)) {
					this.add_trans()
				}
			}
		},
		add_trans() {
			this.table1.data.push({
				timestamp: '',
				transaction: '',
				executiontime: '',
				inputrate: ''
			})

		}
	},
	mounted: function () {
		this.get_input()
		this.get_transactions()
		this.add_trans()
	}
}

</script>


