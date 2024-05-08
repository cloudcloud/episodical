import { createRouter, createWebHistory } from 'vue-router';

export default createRouter({
  history: createWebHistory(),
  routes: [
    {path: '/', name: 'Home', component: () => import('@/components/PageHome')},
    {path: '/episodic', name: 'Episodics', component: () => import('@/components/PageEpisodics')},
    {path: '/artistic', name: 'Artistics', component: () => import('@/components/PageArtistic')},
    {path: '/document', name: 'Documents', component: () => import('@/components/PageDocument')},
    {path: '/config', name: 'Config', component: () => import('@/components/PageConfig')},
    {path: '/episodic/:name', name: 'Episodic', component: () => import('@/components/PageEpisodic'), props: true},
  ],
});
