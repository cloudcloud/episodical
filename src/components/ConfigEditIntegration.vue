<template>
  <v-btn text="Edit" @click="edit" />

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

        <v-combobox
          density="comfortable"
          outlined
          label="Collection Type"
          v-model="type"
          item-title="title"
          item-value="title"
          :items="options" />

        <v-text-field
          v-model="key"
          outlined
          density="comfortable"
          :rules="[]"
          label="Access Key" />

        <v-combobox
          v-model="model"
          outlined
          density="comfortable"
          :rules="[]"
          label="Integration Model"
          :items="models" />
      </v-card-text>

      <v-card-actions>
        <v-spacer />
        <v-btn @click="close" color="primary" text="Cancel" />
        <v-btn @click="save" color="error" text="Save" />
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
    key: '',
    model: '',
    type: '',
    models: [],
    options: [],
  }),
  props: ['item'],
  created() {
    this.id = this.item.id;
    this.title = this.item.title;
    this.key = this.item.access_key;
    this.model = this.item.base_model;
    this.type = this.item.collection_type;
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
      this.$store.dispatch('updateIntegration', {
        id: this.id,
        payload: {
          title: this.title,
          key: this.key,
          model: this.model,
          type: this.type,
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
