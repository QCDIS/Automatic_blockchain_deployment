import DashboardLayout from "@/layout/dashboard/DashboardLayout.vue";
// GeneralViews
import NotFound from "@/pages/NotFoundPage.vue";

// Admin pages
const blockchain_overview = () => import(/* webpackChunkName: "dashboard" */"@/pages/blockchain_overview.vue");
const blockchain_compare = () => import(/* webpackChunkName: "dashboard" */"@/pages/blockchain_compare.vue");
const create_blockchain = () => import(/* webpackChunkName: "common" */ "@/pages/Create_blockchain.vue");
const transaction_requests = () => import(/* webpackChunkName: "common" */ "@/pages/transaction_requests.vue");

const routes = [
  {
    path: "/",
    component: DashboardLayout,
    redirect: "/create_blockchain",
    children: [
      {
        path: "create_blockchain",
        name: "Deploy blockchain",
        component: create_blockchain
      },
      {
        path: "blockchain_overview",
        name: "Blockchain overview",
        component: blockchain_overview
      },
      {
        path: "blockchain_compare",
        name: "Compare blockchains",
        component: blockchain_compare
      },
      {
        path: "transaction_requests",
        name: "Transaction requests",
        component: transaction_requests
      }
    ]
  },
  { path: "*", component: NotFound },
];

/**
 * Asynchronously load view (Webpack Lazy loading compatible)
 * The specified component must be inside the Views folder
 * @param  {string} name  the filename (basename) of the view to load.
function view(name) {
   var res= require('../components/Dashboard/Views/' + name + '.vue');
   return res;
};**/

export default routes;
