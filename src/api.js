import axios from 'axios';

const url = document.querySelector('#EpisodicalBaseURL').getAttribute('content');
const client = axios.create({
  baseURL: url,
  json: true,
});
client.defaults.timeout = 2500;
client.defaults.headers.post['Content-Type'] = 'application/json';
client.defaults.headers.common['X-Client'] = 'episodical 1.0';

export default {

  addEpisodic(payload) {
    return this.perform('post', `/api/v1/episodics/add`, payload);
  },

  addFilesystem(payload) {
    return this.perform('post', `/api/v1/filesystem/add`, payload);
  },

  addIntegration(payload) {
    return this.perform('post', `/api/v1/integrations/add`, payload);
  },

  episodicIntegrationIdentifier(id, payload) {
    return this.perform('post', `/api/v1/episodic/integration/${id}`, payload);
  },

  episodicSearchIntegration(id, title) {
    return this.perform('get', `/api/v1/search/episodic/${id}/${title}`);
  },

  getEpisodic(id) {
    return this.perform('get', `/api/v1/episodic/${id}`);
  },

  getEpisodics() {
    return this.perform('get', `/api/v1/episodics`);
  },

  getFilesystems() {
    return this.perform('get', `/api/v1/filesystems`);
  },

  getIntegrations() {
    return this.perform('get', `/api/v1/integrations`);
  },

  markEpisodeWatched(id, episode_id) {
    return this.perform('get', `/api/v1/episodic/${id}/watched/${episode_id}`);
  },

  markSeasonWatched(id, season_id) {
    return this.perform('get', `/api/v1/episodic/${id}/season/watched/${season_id}`);
  },

  refreshEpisodic(id) {
    return this.perform('get', `/api/v1/episodic/refresh/${id}`);
  },

  removeEpisodic(id) {
    return this.perform('delete', `/api/v1/episodic/delete/${id}`);
  },

  removeFilesystem(id) {
    return this.perform('delete', `/api/v1/filesystem/remove/${id}`);
  },

  removeIntegration(id) {
    return this.perform('delete', `/api/v1/integration/remove/${id}`);
  },

  updateEpisodic(id, payload) {
    return this.perform('put', `/api/v1/episodic/update/${id}`, payload);
  },

  updateFilesystem(id, payload) {
    return this.perform('put', `/api/v1/filesystem/update/${id}`, payload);
  },

  updateIntegration(id, payload) {
    return this.perform('put', `/api/v1/integration/update/${id}`, payload);
  },

  async perform(method, url, data) {
    const headers = {};
    if (method !== 'get') {
      headers['Content-Type'] = 'application/json';
    }

    return client({method, url, data, headers}).then(req => {
      return req.data;
    });
  },
};
