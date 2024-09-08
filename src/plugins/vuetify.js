import '@mdi/font/css/materialdesignicons.css';

import { createVuetify } from 'vuetify';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';
import { episodicalDark, episodicalLight } from '@/plugins/themes.js';

export default createVuetify({
  components,
  directives,
  icons: {
    defaultSet: 'mdi',
  },
  theme: {
    defaultTheme: 'episodicalDark',
    themes: {
      episodicalDark,
      episodicalLight,
    },
  },
});
