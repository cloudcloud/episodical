import { createApp } from 'vue';
import App from '@/App';

import 'vuetify/styles';

import vuetify from '@/plugins/vuetify';
import router from '@/router/index';
import store from '@/store/index';

createApp(App).use(vuetify).use(router).use(store).mount('#app');
