<template>
  <v-btn text="Refresh" prepend-icon="mdi-refresh" @click="refresh" variant="outlined" density="comfortable" class="mx-2" />

  <v-snackbar v-model="snackbar" timeout="5000" color="success">
    Refresh has begun!
    <template v-slot:actions>
      <v-btn text="Close" append-icon="mdi-close" @click="close" variant="outlined" density="comfortable" class="mx-2" />
    </template>
  </v-snackbar>

  <v-snackbar v-model="complete" timeout="10000" color="success">
    Refresh has completed!
    <template v-slot:actions>
      <v-btn text="Close" append-icon="mdi-close" @click="close" variant="outlined" density="comfortable" class="mx-2" />
    </template>
  </v-snackbar>
</template>

<script>
export default {
  data: () => ({
    complete: false,
    snackbar: false,
  }),
  props: ['id'],
  methods: {
    callback() {
      this.complete = true;
    },
    close() {
      this.complete = false;
      this.snackbar = false;
    },
    refresh() {
      this.$store.dispatch('refreshEpisodic', {id: this.id}).then(() => {
        this.snackbar = true;
      });
    },
  },
};
</script>

<style></style>
