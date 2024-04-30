import { createRouter, createWebHistory } from 'vue-router';

export default createRouter({
  history: createWebHistory(),
  routes: [
    {path: '/', name: 'Home', component: () => import('@/components/PageHome')},
    {path: '/episodic', name: 'Episodic', component: () => import('@/components/PageEpisodic')},
    {path: '/artistic', name: 'Artistic', component: () => import('@/components/PageArtistic')},
    {path: '/document', name: 'Document', component: () => import('@/components/PageDocument')},
    {path: '/config', name: 'Config', component: () => import('@/components/PageConfig')},
    {path: '/episodic/:name', name: 'Episodie', component: () => import('@/components/PageEpisodicEpisode'), props: true},
  ],
});
