<template>
  <v-btn prepend-icon="mdi-plus" @click="add" ripple text="Add Episodical" variant="outlined" density="comfortable" class="mx-2" />

  <v-dialog v-model="dialog" max-width="500">
    <v-card :loading="loading" class="mx-auto" title="Add Episodical" width="500">
      <v-card-text>

        <v-text-field
          density="comfortable"
          v-model="title"
          :rules="[rules.required]"
          label="Title" />

        <v-text-field
          density="comfortable"
          v-model="year"
          :rules="[rules.required, rules.numerical]"
          label="Release Year" />

        <v-select
          density="comfortable"
          outlined
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
        <v-btn @click="close" text="Cancel" variant="outlined" density="comfortable" class="mx-2" />
        <v-btn @click="save" color="primary" text="Add" variant="outlined" density="comfortable" class="mx-2" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  data: () => ({
    dialog: false,
    loading: false,
    title: '',
    year: 2000,
    integration: '',
    filesystem: '',
    integrations: [],
    filesystems: [],
    rules: {
      numerical: v => !/[^0-9]+/.test(v) || 'Numbers only.',
      required: v => !!v || 'Required.',
    },
  }),
  computed: {
    ...mapGetters(['allFilesystems', 'allIntegrations']),
  },
  created() {
    this.loadDeps();
  },
  methods: {
    add() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
      this.loading = false;
    },
    loadDeps() {
      this.$store.dispatch('getFilesystems').then(() => {
        this.filesystems = this.$store.getters.allFilesystems;
      });
      this.$store.dispatch('getIntegrations').then(() => {
        this.integrations = this.$store.getters.allIntegrations;
      });
    },
    save() {
      this.loading = true;
      this.$store.dispatch('addEpisodic', {
        title: this.title,
        year: this.year,
        integration: this.integration,
        filesystem: this.filesystem,
        path: this.path,
      }).then(() => {
        this.close();
        this.$emit('addComplete');
      });
    },
  },
};
</script>

<style></style>
