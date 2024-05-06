<template>
  <v-card shaped title="Filesystems">
    <template v-slot:append>
      <ConfigAddFilesystem @addComplete="loadFilesystems" />
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
        <ConfigEditFilesystem :item="item" @editComplete="loadFilesystems" />
        <ConfigRemoveFilesystem :id="item.id" :title="item.title" @removeComplete="loadFilesystems" />
      </template>

    </v-data-table-virtual>
  </v-card>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from 'vuex';
import ConfigAddFilesystem from '@/components/ConfigAddFilesystem';
import ConfigEditFilesystem from '@/components/ConfigEditFilesystem';
import ConfigRemoveFilesystem from '@/components/ConfigRemoveFilesystem';

export default {
  data: () => ({
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Base Path', align: 'left', key: 'base_path'},
      {title: 'Last Checked', align: 'left', key: 'last_checked'},
      {title: 'Actions', align: 'center', key: 'actions'},
    ],
    items: [],
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
    loadFilesystems() {
      this.$store.dispatch('getFilesystems').then(() => {
        this.items = this.$store.getters.allFilesystems;
      });
    },
    ...mapMutations(['resetFilesystems']),
    ...mapActions(['getFilesystems']),
  },
  components: {
    ConfigAddFilesystem,
    ConfigEditFilesystem,
    ConfigRemoveFilesystem,
  },
};
</script>

<style></style>
