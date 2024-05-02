<template>
  <v-card shaped :title="title">
    <template v-slot:append>
      <v-btn
        prepend-icon="mdi-plus"
        x-small
        ripple
        @click="add"
        text="Add" />
    </template>

    <v-data-table-virtual
      v-if="type === 'integrations'"
      :headers="integrations.headers">
    </v-data-table-virtual>

    <v-data-table-virtual
      v-else-if="type === 'filesystems'"
      :headers="filesystems.headers">
    </v-data-table-virtual>
  </v-card>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :loading="loading" class="mx-auto" :title="title" width="500">
      <v-card-text>
        <v-text-field
          v-model="newTitle"
          label="Title"
          outlined
          density="comfortable" />

        <div v-if="type === 'integrations'">
          <v-combobox
            density="comfortable"
            outlined
            label="Collection Type"
            v-model="integrations.type"
            item-title="title"
            item-value="title"
            :items="integrations.items" />

          <v-text-field
            v-model="integrations.key"
            outlined
            density="comfortable"
            :rules="[]"
            label="Access Key" />

          <v-combobox
            v-model="integrations.model"
            outlined
            density="comfortable"
            :rules="[]"
            label="Integration Model"
            :items="integrations.models" />
        </div>

        <div v-else-if="type === 'filesystems'">
          <v-text-field
            v-model="filesystems.path"
            outlined
            density="comfortable"
            :rules="[]"
            label="Base Path" />

          <v-checkbox
            v-model="filesystems.check"
            outlined
            density="comfortable"
            label="Auto Check?" />
        </div>
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
import { mapActions } from 'vuex';

export default {
  data: () => ({
    dialog: false,
    integrations: {
      headers: [
        {title: 'Title', align: 'left', key: 'name'},
        {title: 'Key?', align: 'left', key: 'access_key'},
        {title: 'Base URL', align: 'left', key: 'base_url'},
        {title: 'Type', align: 'left', key: 'collection_type'},
      ],
      items: [
        {title: 'Episodic', value: 'episodic'},
        {title: 'Artistic', value: 'artistic'},
        {title: 'Document', value: 'document'},
      ],
      model: '',
      models: ['thetvdb', 'musicbrainz', 'isbndb', 'openlibrary'],
      key: '',
      type: '',
    },
    filesystems: {
      headers: [
        {title: 'Title', align: 'left', key: 'name'},
        {title: 'Base Path', align: 'left', key: 'base_path'},
        {title: 'Auto', align: 'center', key: 'auto_update'},
        {title: 'Last Checked', align: 'left', key: 'last_checked'},
      ],
      path: '',
      check: false,
    },
    loading: false,
    newTitle: '',
  }),
  props: ['title', 'type'],
  methods: {
    add() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    save() {
      this.loading = true;
      let disp = '';
      let payload = { title: this.newTitle };
      if (this.type === 'filesystems') {
        disp = `addFilesystem`;
        payload.path = this.filesystems.path;
        payload.check = this.filesystems.check;
      } else if (this.type === 'integrations') {
        disp = `addIntegration`;
        payload.key = this.integrations.key;
        payload.type = this.integrations.type;
        payload.model = this.integrations.model;
      }

      this.$store.dispatch(disp, payload).then(() => {
        this.loading = false;
        this.close();
      });
    },
    ...mapActions(['addFilesystem', 'addIntegration']),
  },
};
</script>

<style></style>
