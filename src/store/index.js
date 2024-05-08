import { createStore } from 'vuex';
import apiClient from '@/api';

export default createStore({
  state: {
    episodics: {},
    filesystems: {},
    integrations: {},
  },

  mutations: {
    resetEpisodic(state, ep) {
      state.episodics[ep.name] = ep;
    },
    resetEpisodics(state, eps) {
      state.episodics = eps.data;
    },
    resetFilesystems(state, fs) {
      state.filesystems = fs.data;
    },
    resetIntegrations(state, i) {
      state.integrations = i.data;
    },
  },

  getters: {
    allEpisodics: state => {
      return state.episodics;
    },
    allFilesystems: state => {
      return state.filesystems;
    },
    allIntegrations: state => {
      return state.integrations;
    },
  },

  actions: {

    addEpisodic({commit}, payload) {
      return new Promise((resolve) => {
        apiClient.addEpisodic(payload).then((data) => {
          if (data.errors.length < 1 && data.meta.errors < 1) {
            commit('resetEpisodic', data);
          }
          resolve();
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

    getEpisodics({commit}) {
      return new Promise((resolve) => {
        apiClient.getEpisodics().then((data) => {
          if (data.errors.length < 1 && data.meta.errors < 1) {
            commit('resetEpisodics', data);
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
