<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card
          :title="title"
          shaped>

          <v-data-table :headers="headers" :items="items">
          </v-data-table>

        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapState } from 'vuex';

export default {
  data: () => ({
    headers: [],
    items: [],
    loading: false,
    releaseYear: 2000,
    title: 'Episodic',
  }),
  components: {
  },
  computed: {
    ...mapState(['episodic']),
  },
  created() {
    this.loadEpisodic();
    this.title = this.name + ' (' + this.releaseYear + ')';
  },
  props: ['name'],
  methods: {
    loadEpisodic() {
      this.$store.dispatch('getEpisodic', {name: this.name});
    },
    ...mapActions(['getEpisodic']),
  },
};
</script>

<style></style>
