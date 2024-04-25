import { createRouter, createWebHistory } from 'vue-router';

export default createRouter({
  history: createWebHistory(),
  routes: [
    {path: '/', name: 'Home', component: () => import('@/components/PageHome')},
    {path: '/collections', name: 'Collections', component: () => import('@/components/PageCollections')},
    {path: '/config', name: 'Config', component: () => import('@/components/PageConfig')},
    {path: '/episodic/:name', name: 'Episodic', component: () => import('@/components/PageEpisodic'), props: true},
  ],
});
