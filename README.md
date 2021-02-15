# iB-Demander

## Table of Contents


* [Demo](#demo)
* [Quick Start](#quick-start)
* [User Guide](#user-guide)
* [Architecture](#architecture)
* [File Structure](#file-structure)
* [Prototype](#prototype)
* [Dataflow](#dataflow)
* [Technical Support or Questions](#technical-support-or-questions)
* [Reach me](#reach-me)


## Demo

![](./overview/demo_gif.gif)


iB-Demander is an interactive user environment that allows for automatic blockchain deployment and performance profiling through which various blockchains can be benchmarked.
The benchmark result provides insight in which blockchain configuration is best suited for the concerning business purpose.


[Download from Github](https://github.com/JardennaM/blockchain_tool).


## Quick start

- Clone the repo: `$ git clone https://github.com/JardennaM/blockchain_tool.git`
- Open a new terminal window
- Navigate to blockchain_tool folder `$ cd ./blockchain_tool`
- Install dependencies `$ npm install`
- Start server `$ npm run start`
- Open a new terminal window
- Navigate to client folder `$ cd client`
- Start application `$ npm run serve`


## User guide

- To deploy a blockchain in the cloud, fill out the form on the 'deploy blockchain' page.
- Specify the following:
    - Blockchain type
    - Consensus algorithm
    - Cloud environment
    - Amount of instances
    - Geographical zone
    - Operating system
    - Instance type
- Wait 15 minutes for the blockchain to be completely deployed in the cloud.
- Navigate to blockchain overview by using the sidebar.
- Click the button to retrieve the blockchains.
- Send a transaction request to the desired blockchain via the 'send transaction button'.
- With the sliders specify the execution time and input rate.
- Click on the X in the right corner to close the 'send transaction' window.
- From here the performance can be viewed by clicking the 'view performnace' button.
- Wait for the automatic configuring of the dashboard.
- Follow the instructions on the notification.
- If more than 1 blockchain is deployed it can be compared with the compare performance page.
- Here up to three blockchains can be compared.
- Lastly an overiew of all transactions can be found when navigating to the 'transaction overview' page.



## Architecture

![Alt text](./overview/iB-Demander.png?raw=true "Architecture")



## File Structure
Within the download you'll find the following directories and files:

```
|-- blockchain_tool
    ├── README.md
    ├── client
    │   ├── intelij.webpack.js
    │   ├── node_modules
    │   ├── package-lock.json
    │   ├── package.json
    │   ├── public
    │   │   ├── img
    │   │   │   └── icons
    │   │   │       └── block.png
    │   │   ├── index.html
    │   │   ├── manifest.json
    │   │   └── robots.txt
    │   ├── src
    │   │   ├── App.vue
    │   │   ├── assets
    │   │   │   ├── css
    │   │   │   │   └── nucleo-icons.css
    │   │   │   ├── demo
    │   │   │   │   └── demo.css
    │   │   │   ├── fonts
    │   │   │   │   ├── nucleo.eot
    │   │   │   │   ├── nucleo.ttf
    │   │   │   │   ├── nucleo.woff
    │   │   │   │   └── nucleo.woff2
    │   │   │   └── sass
    │   │   │       ├── black-dashboard
    │   │   │       │   ├── bootstrap
    │   │   │       │   ├── custom
    │   │   │       │   └── plugins
    │   │   │       └── black-dashboard.scss
    │   │   ├── components
    │   │   │   ├── BaseAlert.vue
    │   │   │   ├── BaseButton.vue
    │   │   │   ├── BaseCheckbox.vue
    │   │   │   ├── BaseDropdown.vue
    │   │   │   ├── BaseNav.vue
    │   │   │   ├── BaseRadio.vue
    │   │   │   ├── BaseTable.vue
    │   │   │   ├── Cards
    │   │   │   │   ├── Card.vue
    │   │   │   │   └── StatsCard.vue
    │   │   │   ├── Charts
    │   │   │   │   ├── BarChart.js
    │   │   │   │   ├── LineChart.js
    │   │   │   │   ├── config.js
    │   │   │   │   └── utils.js
    │   │   │   ├── CloseButton.vue
    │   │   │   ├── Inputs
    │   │   │   │   └── BaseInput.vue
    │   │   │   ├── Modal.vue
    │   │   │   ├── NavbarToggleButton.vue
    │   │   │   ├── NotificationPlugin
    │   │   │   │   ├── Notification.vue
    │   │   │   │   ├── Notifications.vue
    │   │   │   │   └── index.js
    │   │   │   ├── SidebarPlugin
    │   │   │   │   ├── SideBar.vue
    │   │   │   │   ├── SidebarLink.vue
    │   │   │   │   └── index.js
    │   │   │   └── index.js
    │   │   ├── config.js
    │   │   ├── dependent_dropdown.js
    │   │   ├── directives
    │   │   │   └── click-ouside.js
    │   │   ├── i18n.js
    │   │   ├── layout
    │   │   │   ├── dashboard
    │   │   │   │   ├── Content.vue
    │   │   │   │   ├── ContentFooter.vue
    │   │   │   │   ├── DashboardLayout.vue
    │   │   │   │   ├── MobileMenu.vue
    │   │   │   │   └── TopNavbar.vue
    │   │   │   └── starter
    │   │   │       ├── Content.vue
    │   │   │       ├── MobileMenu.vue
    │   │   │       ├── SampleFooter.vue
    │   │   │       ├── SampleLayout.vue
    │   │   │       ├── SampleNavbar.vue
    │   │   │       └── SamplePage.vue
    │   │   ├── locales
    │   │   │   └── en.json
    │   │   ├── main.js
    │   │   ├── pages
    │   │   │   ├── Create_blockchain.vue
    │   │   │   ├── Dashboard
    │   │   │   │   └── UserTable.vue
    │   │   │   ├── NotFoundPage.vue
    │   │   │   ├── Notifications
    │   │   │   │   ├── NotificationTemplate.vue
    │   │   │   │   └── login_notification.vue
    │   │   │   ├── blockchain_compare.vue
    │   │   │   ├── blockchain_overview.vue
    │   │   │   └── transaction_requests.vue
    │   │   ├── plugins
    │   │   │   ├── RTLPlugin.js
    │   │   │   ├── blackDashboard.js
    │   │   │   ├── globalComponents.js
    │   │   │   └── globalDirectives.js
    │   │   ├── registerServiceWorker.js
    │   │   ├── router
    │   │   │   ├── index.js
    │   │   │   ├── routes.js
    │   │   │   └── starterRouter.js
    │   │   └── user_input_service.js
    │   ├── vue.config.js
    │   └── webpack.config.js
    ├── cloud_storm
    │   ├── CloudsStorm-b.1.2.jar
    │   ├── cloud
    │   │   └── template_folder
    │   │       ├── App
    │   │       ├── Infs
    │   │       │   ├── Topology
    │   │       │   │   ├── clusterKeyPair
    │   │       │   │   │   ├── id_rsa
    │   │       │   │   │   └── id_rsa.pub
    │   │       │   │   ├── test
    │   │       │   │   └── test.pub
    │   │       │   ├── UC
    │   │       │   │   ├── EC2.yml
    │   │       │   │   ├── ExoGENI.yml
    │   │       │   │   ├── cred.yml
    │   │       │   │   └── user.jks
    │   │       │   └── UD
    │   │       │       ├── EC2.yml
    │   │       │       ├── ExoGENI.yml
    │   │       │       └── db.yml
    │   │       └── Logs
    │   ├── flukes.jnlp
    │   └── scripts
    │       ├── configure_blockchain.sh
    │       ├── delete_blockchain.sh
    │       ├── get_ip.sh
    │       └── send_transaction.sh
    ├── node_modules
    ├── overview
    │   ├── demo.mp4
    │   ├── iB-Demander-detailed.png
    │   ├── iB-Demander.png
    │   ├── performance_profiling
    │   │   ├── compare_cloud_environements
    │   │   │   ├── cloud1.png
    │   │   │   ├── cloud10.png
    │   │   │   ├── cloud11.png
    │   │   │   ├── cloud12.png
    │   │   │   ├── cloud13.png
    │   │   │   ├── cloud2.png
    │   │   │   ├── cloud3.png
    │   │   ├── cloud5.png
    │   │   │   ├── cloud6.png
    │   │   │   ├── cloud7.png
    │   │   │   ├── cloud8.png
    │   │   │   └── cloud9.png
    │   │   └── compare_consensus_algorithms
    │   │       ├── consensus1.png
    │   │       ├── consensus10.png
    │   │       ├── consensus2.png
    │   │       ├── consensus3.png
    │   │       ├── consensus4.png
    │   │       ├── consensus5.png
    │   │       ├── consensus6.png
    │   │       ├── consensus7.png
    │   │       ├── consensus8.png
    │   │       └── consensus9.png
    │   └── tree.txt
    ├── package-lock.json
    ├── package.json
    ├── server
    │   ├── index.js
    │   ├── json_files
    │   │   ├── input.json
    │   │   └── transaction.json
    │   └── routes
    │       └── api
    │           └── user_input.js
    └── yarn.lock

```


## Style template:
Copyright 2018 Creative Tim (https://www.creative-tim.com/)



## Prototype
The current prototype supports the following blockchain configurations:
- Blockchain type
    - Sawtooth
- Cloud environments
    - Amazon Web Services (AWS)
    - ExoGENI
- Virtual machine operating system:
    - Ubuntu 16.04
- Virtual machine instance types:
    - XOsmall
    - XOmedium
    - t2.nano
    - t2.micro
    - t2.medium


## Dataflow

![Alt text](./overview/iB-Demander-detailed.png?raw=true "Detailed architecture")

<!-- ## Technical Support or Questions

If you have questions or need help integrating the product please contact me: jardenna.nl@gmail.com -->


## Reach me

Linkedin: <https://www.linkedin.com/in/jardenna-mohazzab-461447122/>

Mail: jardenna.nl@gmail.com

