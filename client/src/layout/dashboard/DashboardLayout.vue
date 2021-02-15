<template>
  <div class="wrapper">
    <side-bar>
      <template slot="links">
        <sidebar-link to="/create_blockchain" :name="$t('sidebar.create_blockchain')" icon="tim-icons icon-cloud-upload-94"/>
        <sidebar-link to="/blockchain_overview" :name="$t('sidebar.blockchain_overview')" icon="tim-icons icon-app"/>
        <sidebar-link to="/blockchain_compare" :name="$t('sidebar.blockchain_compare')" icon="tim-icons icon-components"/>
        <sidebar-link to="/transaction_requests" :name="$t('sidebar.transaction_requests')" icon="tim-icons icon-notes"/>


      </template>
    </side-bar>
    <div class="main-panel">
      <top-navbar></top-navbar>

      <dashboard-content @click.native="toggleSidebar">

      </dashboard-content>

      <content-footer></content-footer>
    </div>
  </div>
</template>
<style lang="scss">
</style>
<script>
import TopNavbar from "./TopNavbar.vue";
import ContentFooter from "./ContentFooter.vue";
import DashboardContent from "./Content.vue";
import MobileMenu from "./MobileMenu";
export default {
  components: {
    TopNavbar,
    ContentFooter,
    DashboardContent,
    MobileMenu
  },
  methods: {
    toggleSidebar() {
      if (this.$sidebar.showSidebar) {
        this.$sidebar.displaySidebar(false);
      }
    }
  }
};
</script>
