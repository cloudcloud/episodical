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

    addEpisodic({commit}, {payload}) {
      return new Promise((resolve) => {
        apiClient.addEpisodic(payload).then((data) => {
          //
        });
      });
    },

    addFilesystem(_, {payload}) {
      console.log(payload);
      return apiClient.addFilesystem(payload);
    },

    addIntegration(_, {payload}) {
      console.log(payload);
      return apiClient.addIntegration(payload)
    },

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
