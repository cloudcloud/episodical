<template>
  <v-card shaped title="Filesystems">
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
      :items="items">

      <template v-slot:item.last_checked="{ item }">
        <v-chip v-if="item.auto_update">
          {{ item.last_checked }}
        </v-chip>
        <v-chip color="gray" disabled variant="plain" v-else>
          Not Auto-Updating
        </v-chip>
      </template>
      <template v-slot:item.actions="{ item }">
        <v-btn text="Edit" />
        <v-btn text="Remove" color="error" />
      </template>

    </v-data-table-virtual>
  </v-card>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :loading="loading" class="mx-auto" title="Add New Filesystem Path" width="500">
      <v-card-text>
        <v-text-field
          v-model="newTitle"
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
        <v-btn @click="close" text="Cancel" />
        <v-btn @click="save" color="primary" text="Add" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from 'vuex';

export default {
  data: () => ({
    dialog: false,
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Base Path', align: 'left', key: 'base_path'},
      {title: 'Last Checked', align: 'left', key: 'last_checked'},
      {title: 'Actions', align: 'center', key: 'actions'},
    ],
    path: '',
    check: false,
    items: [],
    loading: false,
    newTitle: '',
  }),
  computed: {
    ...mapGetters(['allFilesystems']),
  },
  created() {
    this.$store.dispatch('getFilesystems').then(() => {
      this.loadFilesystems();
    });
  },
  methods: {
    add() {
      this.dialog = true;
    },
    close() {
      this.loading = false;
      this.dialog = false;
    },
    loadFilesystems() {
      this.$store.dispatch('getFilesystems').then(() => {
        this.items = this.$store.getters.allFilesystems;
      });
    },
    save() {
      this.loading = true;
      let payload = {
        title: this.newTitle,
        path: this.path,
        check: this.check,
      };
      this.$store.dispatch('addFilesystem', payload).then(() => {
        this.close();
      });
    },
    ...mapMutations(['resetFilesystems']),
    ...mapActions(['addFilesystem', 'getFilesystems']),
  },
};
</script>

<style></style>
