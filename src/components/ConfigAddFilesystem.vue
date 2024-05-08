<template>
  <v-btn
    text="Add"
    @click="add"
    prepend-icon="mdi-plus"
    x-small
    ripple variant="outlined" density="comfortable" class="mx-2" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      title="Add New Filesystem Path"
      class="mx-auto"
      width="500">

      <v-card-text>
        <v-text-field
          v-model="title"
          label="Title"
          outlined
          density="comfortable" />

        <v-text-field
          v-model="path"
          outlined
          density="comfortable"
          :rules="[]"
          label="Base Path" />

        <v-checkbox
          v-model="check"
          outlined
          density="comfortable"
          label="Auto Check?" />
      </v-card-text>

      <v-card-actions>
        <v-spacer />
        <v-btn @click="close" color="primary" text="Cancel" variant="outlined" density="comfortable" class="mx-2" />
        <v-btn @click="save" color="error" text="Save" variant="outlined" density="comfortable" class="mx-2" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    dialog: false,
    loading: false,
    title: '',
    path: '',
    check: false,
  }),
  methods: {
    close() {
      this.loading = false;
      this.dialog = false;
    },
    add() {
      this.dialog = true;
    },
    save() {
      this.loading = true;
      this.$store.dispatch('addFilesystem', {
        title: this.title,
        path: this.path,
        check: this.check,
      }).then(() => {
        this.close();
        this.$emit('addComplete');
      });
    },
  },
};
</script>

<style></style>


