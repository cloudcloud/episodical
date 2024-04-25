import axios from 'axios';

const url = document.querySelector('#EpisodicalBaseURL').getAttribute('content');
const client = axios.create({
  baseURL: url,
  json: true,
});

export default {

  getEpisodic(name) {
    return this.perform('get', `/api/v1/${name}`);
  },

  async perform(method, resource, data) {
    return client({
      method,
      url: resource,
      data,
      headers: {
        'X-Client': 'episodical 1.0',
      },
    }).then(req => {
      return req.data;
    });
  },
};
