import { createStore } from 'vuex';
import apiClient from '@/api';

export default createStore({
  state: {
    episodic: {},
    filesystems: {},
  },

  mutations: {
    resetEpisodic(state, ep) {
      state.episodic[ep.name] = ep;
    },
    resetFilesystems(state, fs) {
      state.filesystems = fs.data;
    },
  },

  getters: {
    allFilesystems: state => {
      return state.filesystems;
    },
  },

  actions: {

    addEpisodic({commit}, {payload}) {
      return new Promise((resolve) => {
        apiClient.addEpisodic(payload).then((data) => {
          //
        });
      });
    },

    addFilesystem(_, payload) {
      return apiClient.addFilesystem(payload);
    },

    addIntegration(_, payload) {
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

    getFilesystems({commit}) {
      return new Promise((resolve) => {
        apiClient.getFilesystems().then((data) => {
          if (data.errors.length < 1 && data.meta.errors < 1) {
            commit('resetFilesystems', data);
          }
          resolve();
        });
      });
    },

  },
});
