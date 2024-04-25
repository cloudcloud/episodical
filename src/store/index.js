import { createStore } from 'vuex';
import apiClient from '@/api';

export default createStore({
  state: {
    episodic: {},
  },

  mutations: {
    resetEpisodic(state, ep) {
      state.episodic[ep.name] = ep;
    },
  },

  getters: {},

  actions: {

    getEpisodic({commit}, {name}) {
      return new Promise((resolve) => {
        apiClient.getEpisodic(name).then((data) => {
          if (data.meta && data.meta.errors && data.meta.errors.length < 1) {
            commit('resetShow', data);
          }
          resolve();
        });
      });
    },

  },
});
