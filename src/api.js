import axios from 'axios';

const url = document.querySelector('#FOBaseURL').getAttribute('content');
const client = axios.create({
  baseURL: url,
  json: true,
});

export default {
  async perform(method, resource, data) {
    return client({
      method,
      url: resource,
      data,
      headers: {
        'X-Client': 'file-organization 1.0',
      },
    }).then(req => {
      return req.data;
    });
  },
};
