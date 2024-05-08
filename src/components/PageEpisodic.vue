<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card
          :title="title"
          shaped>

          <template v-slot:append>
            <v-btn @click="edit" prepend-icon="mdi-pencil" text="Edit" color="primary" variant="outlined" density="comfortable" class="mx-2" />
            <v-btn @click="remove" prepend-icon="mdi-trash-can" text="Remove" color="error" variant="outlined" density="comfortable" class="mx-2" />
          </template>

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
