<template>
  <v-app>
    <Header></Header>

    <v-main>
      <v-container fluid>
        <router-view />
      </v-container>
    </v-main>

  </v-app>
</template>

<script>
import Header from '@/components/Header';

export default {
  name: 'App',
  components: {
    Header,
  },
  data () {
    return {}
  }
}
</script>

<style></style>
