<template>
  <v-btn text="Remove" color="error" @click="remove" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      :title="'Removing ' + title"
      class="mx-auto"
      width="500"
      subtitle="Are you sure you wish to remove the filesystem?">

      <v-card-actions>
        <v-btn @click="close" color="primary" text="No" />
        <v-btn @click="run" color="error" text="Yes" />
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
      this.$store.dispatch('removeFilesystem', { id: this.id }).then(() => {
        this.close();
        this.$emit('removeComplete');
      });
    },
  },
};
</script>

<style></style>
