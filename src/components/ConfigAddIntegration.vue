<template>
  <v-btn
    prepend-icon="mdi-plus"
    x-small
    ripple
    @click="add"
    text="Add" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      title="Add New Integration Configuration"
      class="mx-auto"
      width="500">
      <v-card-text>
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
    title: '',
    type: '',
    key: '',
    model: '',
    models: ['thetvdb', 'musicbrainz', 'isbndb', 'openlibrary'],
    options: [
      {title: 'Episodic', value: 'episodic'},
      {title: 'Artistic', value: 'artistic'},
      {title: 'Document', value: 'document'},
    ],
  }),
  methods: {
    add() {
      this.dialog = true;
    },
    close() {
      this.loading = false;
      this.dialog = false;
    },
    save() {
      this.loading = true;
      this.$store.dispatch('addIntegration', {
        title: this.title,
        type: this.type.value,
        key: this.key,
        model: this.model,
      }).then(() => {
        this.close();
        this.$emit('addComplete');
      });
    },
  },
};
</script>

<style></style>
