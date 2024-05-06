import { createStore } from 'vuex';
import apiClient from '@/api';

export default createStore({
  state: {
    episodic: {},
    filesystems: {},
    integrations: {},
  },

  mutations: {
    resetEpisodic(state, ep) {
      state.episodic[ep.name] = ep;
    },
    resetFilesystems(state, fs) {
      state.filesystems = fs.data;
    },
    resetIntegrations(state, i) {
      state.integrations = i.data;
    },
  },

  getters: {
    allFilesystems: state => {
      return state.filesystems;
    },
    allIntegrations: state => {
      return state.integrations;
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

    getIntegrations({commit}) {
      return new Promise((resolve) => {
        apiClient.getIntegrations().then((data) => {
          if (data.errors.length < 1 && data.meta.errors < 1) {
            commit('resetIntegrations', data);
          }
          resolve();
        });
      });
    },

    removeFilesystem(_, {id}) {
      return apiClient.removeFilesystem(id);
    },

    removeIntegration(_, {id}) {
      return apiClient.removeIntegration(id);
    },

    updateFilesystem(_, {id, payload}) {
      return apiClient.updateFilesystem(id, payload);
    },

    updateIntegration(_, {id, payload}) {
      return apiClient.updateIntegration(id, payload);
    },

  },
});
