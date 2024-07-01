<template>
  <v-btn text="Edit" prepend-icon="mdi-pencil" @click="edit" variant="outlined" density="comfortable" class="mx-2" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card
      :loading="loading"
      :title="'Updating ' + title + ' (' + year + ')'"
      class="mx-auto"
      width="500">

      <v-card-text>
        <v-text-field
          density="comfortable"
          disabled
          :model-value="id"
          label="ID" />

        <v-text-field
          density="comfortable"
          v-model="title"
          :rules="[rules.required]"
          label="Title" />

        <v-text-field
          density="comfortable"
          v-model.number="year"
          type="number"
          :rules="[]"
          label="Release Year" />

        <v-select
          density="comfortable"
          label="Integration"
          v-model="integration"
          item-title="title"
          item-value="id"
          clearable
          :items="integrations" />

        <v-select
          density="comfortable"
          outlined
          label="Filesystem"
          v-model="filesystem"
          item-title="title"
          item-value="id"
          clearable
          :items="filesystems" />

        <div v-if="filesystem !== '' && filesystem !== null">
          <v-text-field
            density="comfortable"
            label="Sub Path"
            v-model="path"
            :rules="[]" />
        </div>

      </v-card-text>

      <v-card-actions>
        <v-spacer />
        <v-btn @click="close" color="primary" text="No" variant="outlined" density="comfortable" class="mx-2" />
        <v-btn @click="run" color="error" text="Yes" variant="outlined" density="comfortable" class="mx-2" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapGetters, mapState } from 'vuex';

export default {
  data: () => ({
    dialog: false,
    loading: false,
    title: '',
    year: 2000,
    integration: '',
    filesystem: '',
    path: '',
    integrations: [],
    filesystems: [],
    rules: {
      numerical: v => !/[^0-9]+/.test(v) || 'Numbers only.',
      required: v => !!v || 'Required.',
    },
  }),
  props: ['id'],
  computed: {
    ...mapGetters(['allFilesystems', 'allIntegrations']),
    ...mapState(['episodic']),
  },
  created() {
    this.loadDeps();
  },
  methods: {
    close() {
      this.loading = false;
      this.dialog = false;
    },
    edit() {
      this.dialog = true;
    },
    loadDeps() {
      this.$store.dispatch('getFilesystems').then(() => {
        this.filesystems = this.$store.getters.allFilesystems;
        this.$store.dispatch('getIntegrations').then(() => {
          this.integrations = this.$store.getters.allIntegrations;
          this.$store.dispatch('getEpisodic', {id: this.id}).then(() => {
            this.title = this.episodic[this.id].episodic.title;
            this.year = this.episodic[this.id].episodic.year;
            this.integration = this.episodic[this.id].episodic.integration_id;
            this.filesystem = this.episodic[this.id].episodic.filesystem_id;
            this.path = this.episodic[this.id].episodic.path;
          });
        });
      });
    },
    run() {
      this.loading = true;
      this.$store.dispatch('updateEpisodic', {
        id: this.id,
        payload: {
          title: this.title,
          year: this.year,
          integration: this.integration,
          filesystem: this.filesystem,
          path: this.path,
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
