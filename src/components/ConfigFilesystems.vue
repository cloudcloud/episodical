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
        <v-chip v-if="item.auto_update" variant="outline" color="success">
          {{ item.last_checked }}
        </v-chip>
        <v-chip color="gray" disabled variant="plain" v-else>
          Not Auto-Updating
        </v-chip>
      </template>
      <template v-slot:item.actions="{ item }">
        <v-btn text="Edit" @click="edit(item.id)" />
        <v-btn text="Remove" color="error" @click="remove(item.id)" />
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

  <v-dialog v-model="editDialog" max-width="500">
    <v-card :loading="editLoading" class="mx-auto" title="Update Filesystem" width="500">
      <v-card-text>
        <v-text-field
          v-model="editID"
          disabled
          label="ID"
          outlined
          density="comfortable" />

        <v-text-field
          v-model="editTitle"
          label="Title"
          outlined
          density="comfortable" />

        <v-text-field
          v-model="editPath"
          outlined
          density="comfortable"
          :rules="[]"
          label="Base Path" />

        <v-checkbox
          v-model="editCheck"
          outlined
          density="comfortable"
          label="Auto Check?" />

      </v-card-text>

      <v-card-actions>
        <v-spacer />
        <v-btn @click="close" text="Cancel" />
        <v-btn @click="runEdit" color="primary" text="Update" />
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog v-model="removeDialog" max-width="500">
    <v-card
      :loading="removeLoading"
      :title="'Removing ' + removeTitle"
      class="mx-auto"
      width="500"
      subtitle="Are you sure you wish to remove the filesystem?">

      <v-card-actions>
        <v-btn @click="close" color="primary" text="No" />
        <v-btn @click="runRemove" color="error" text="Yes" />
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

    editDialog: false,
    editLoading: false,
    editTitle: '',
    editPath: '',
    editCheck: false,
    editID: '',

    removeDialog: false,
    removeLoading: false,
    removeID: '',
    removeTitle: '',
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
      this.editLoading = false;
      this.removeLoading = false;
      this.dialog = false;
      this.editDialog = false;
      this.removeDialog = false;
    },
    edit(id) {
      this.editDialog = true;
      this.editLoading = false;
      const entry = this.items.filter((item) => item.id === id)[0];
      this.editID = entry.id;
      this.editTitle = entry.title;
      this.editPath = entry.base_path;
      this.editCheck = entry.auto_update;
    },
    remove(id) {
      this.removeDialog = true;
      this.removeLoading = false;
      const entry = this.items.filter((item) => item.id === id)[0];
      this.removeID = id;
      this.removeTitle = entry.title;
    },
    runEdit() {
      this.editLoading = true;
      this.$store.dispatch('updateFilesystem', {
        id: this.editID, 
        payload: {
          title: this.editTitle,
          path: this.editPath,
          check: this.editCheck,
        },
      }).then(() => {
        this.close();
        this.loadFilesystems();
      });
    },
    runRemove() {
      this.removeLoading = true;
      this.$store.dispatch('removeFilesystem', { id: this.removeID }).then(() => {
        this.close();
        this.loadFilesystems();
      });
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
        this.loadFilesystems();
      });
    },
    ...mapMutations(['resetFilesystems']),
    ...mapActions(['addFilesystem', 'getFilesystems']),
  },
};
</script>

<style></style>
