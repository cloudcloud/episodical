import axios from 'axios';

const url = document.querySelector('#EpisodicalBaseURL').getAttribute('content');
const client = axios.create({
  baseURL: url,
  json: true,
});
client.defaults.timeout = 2500;
client.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
client.defaults.headers.common['X-Client'] = 'episodical 1.0';

export default {

  addEpisodic(payload) {
    return this.perform('post', `/api/v1/episodics/add`, payload);
  },

  addFilesystem(payload) {
    return this.perform('post', `/api/v1/filesystems/add`, payload);
  },

  addIntegration(payload) {
    return this.perform('post', `/api/v1/integrations/add`, payload);
  },

  getEpisodic(name) {
    return this.perform('get', `/api/v1/episodic/${name}`);
  },

  async perform(method, resource, data) {
    return client({
      method: method,
      url: resource,
      data: data,
    }).then(req => {
      return req.data;
    });
  },
};
