<template>
  <v-btn text="Edit" prepend-icon="mdi-pencil" @click="edit" variant="outlined" density="comfortable" class="mx-2" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      :title="'Editing ' + title"
      class="mx-auto"
      width="500">
      <v-card-text>
        <v-text-field
          v-model="id"
          disabled
          label="ID"
          outlined
          density="comfortable" />

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
    id: '',
    title: '',
    path: '',
    check: false,
  }),
  props: ['item'],
  created() {
    this.id = this.item.id;
    this.title = this.item.title;
    this.path = this.item.base_path;
    this.check = this.item.auto_update;
  },
  methods: {
    close() {
      this.loading = false;
      this.dialog = false;
    },
    edit() {
      this.dialog = true;
    },
    save() {
      this.loading = true;
      this.$store.dispatch('updateFilesystem', {
        id: this.id,
        payload: {
          title: this.title,
          path: this.path,
          check: this.check,
        },
      }).then(() => {
        this.close();
        this.$emit('editComplete');
      });
    },
  },
};
</script>

<style></style>

