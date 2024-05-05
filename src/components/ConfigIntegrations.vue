<template>
  <v-card shaped title="Integrations">
    <template v-slot:append>
      <v-btn
        prepend-icon="mdi-plus"
        x-small
        ripple
        @click="add"
        text="Add" />
    </template>

    <v-data-table-virtual
      :headers="headers"
      :items="items" />
  </v-card>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :loading="loading" class="mx-auto" title="Add Integration Configuration" width="500">
      <v-card-text>
        <v-text-field
          v-model="newTitle"
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
        <v-btn @click="close" text="Cancel" />
        <v-btn @click="save" color="primary" text="Add" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>

export default {
  data: () => ({
    dialog: false,
    loading: false,
    headers: [],
    items: [],
    models: ['thetvtdb', 'musicbrainz', 'isbndb', 'openlibrary'],
    options: [
      {title: 'Episodic', value: 'episodic'},
      {title: 'Artistic', value: 'artistic'},
      {title: 'Document', value: 'document'},
    ],
    newTitle: '',
    type: '',
    key: '',
    model: '',
  }),
};
</script>

<style></style>
