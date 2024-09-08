<template>
  <v-app-bar app>
    <v-spacer></v-spacer>

    <v-btn class="mx-2" ripple small to="/">Home</v-btn>
    <v-btn class="mx-2" ripple small to="/episodic">Episodic</v-btn>
    <v-btn class="mx-2" ripple small to="/artistic">Artistic</v-btn>
    <v-btn class="mx-2" ripple small to="/document">Document</v-btn>
    <v-btn class="mx-2" ripple small to="/config">Config</v-btn>

    <v-spacer></v-spacer>
    <v-btn class="mx-2" ripple small @click="toggle" icon="mdi-moon-waxing-crescent" />
  </v-app-bar>
</template>

<script setup>
import { useTheme } from 'vuetify';
const theme = useTheme();
function toggle() {
  theme.global.name.value = theme.global.current.value.dark ? 'light' : 'dark';
}
</script>

<script>
export default {
  data() {
    return {};
  },
  methods: {},
};
</script>

<style></style>
