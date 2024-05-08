<template>
  <v-btn text="Remove" prepend-icon="mdi-trash-can" color="error" @click="remove" variant="outlined" density="comfortable" class="mx-2" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      :title="'Removing ' + title"
      class="mx-auto"
      width="500"
      subtitle="Are you sure you wish to remove this Episodic?">

      <v-card-actions>
        <v-spacer />
        <v-btn @click="close" color="primary" text="No" variant="outlined" density="comfortable" class="mx-2" />
        <v-btn @click="run" color="error" text="Yes" variant="outlined" density="comfortable" class="mx-2" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    dialog: false,
    loading: false,
  }),
  props: ['id', 'title'],
  methods: {
    close() {
      this.loading = false;
      this.dialog = false;
    },
    remove() {
      this.dialog = true;
    },
    run() {
      this.loading = true;
      this.$store.dispatch('removeEpisodic', { id: this.id }).then(() => {
        this.close();
        this.$emit('removeComplete');
      });
    },
  },
};
</script>

<style></style>
