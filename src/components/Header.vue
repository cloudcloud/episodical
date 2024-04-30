<template>
  <v-app-bar color="green-darken-4" app>
    <v-spacer></v-spacer>

    <v-btn class="mx-2" ripple small to="/">Home</v-btn>
    <v-btn class="mx-2" ripple small to="/episodic">Episodic</v-btn>
    <v-btn class="mx-2" ripple small to="/artistic">Artistic</v-btn>
    <v-btn class="mx-2" ripple small to="/document">Document</v-btn>
    <v-btn class="mx-2" ripple small to="/config">Config</v-btn>

    <v-spacer></v-spacer>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {};
  },
  methods: {},
};
</script>

<style></style>
