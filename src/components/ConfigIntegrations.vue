<template>
  <v-card shaped title="Integrations">
    <template v-slot:append>
      <ConfigAddIntegration @addComplete="loadIntegrations" />
    </template>

    <v-data-table-virtual :headers="headers" :items="items">

      <template v-slot:item.key="{ item }">
        <v-chip v-if="item.access_key != ''" variant="outline" color="success">
          Added!
        </v-chip>
        <v-chip v-else color="gray" disabled variant="plain">
          Not added.
        </v-chip>
      </template>
      <template v-slot:item.actions="{ item }">
        <ConfigEditIntegration :item="item" @editComplete="loadIntegrations" />
        <ConfigRemoveIntegration :id="item.id" :title="item.title" @removeComplete="loadIntegrations" />
      </template>

    </v-data-table-virtual>
  </v-card>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from 'vuex';
import ConfigAddIntegration from '@/components/ConfigAddIntegration';
import ConfigEditIntegration from '@/components/ConfigEditIntegration';
import ConfigRemoveIntegration from '@/components/ConfigRemoveIntegration';

export default {
  data: () => ({
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Access Key', align: 'left', key: 'key'},
      {title: 'Model', align: 'left', key: 'base_model'},
      {title: 'Type', align: 'left', key: 'collection_type'},
      {title: 'Actions', align: 'center', key: 'actions'},
    ],
    items: [],
  }),
  computed: {
    ...mapGetters(['allIntegrations']),
  },
  created() {
    this.loadIntegrations();
  },
  methods: {
    loadIntegrations() {
      this.$store.dispatch('getIntegrations').then(() => {
        this.items = this.$store.getters.allIntegrations;
      });
    },
    ...mapMutations(['resetIntegrations']),
    ...mapActions(['getIntegrations']),
  },
  components: {
    ConfigAddIntegration,
    ConfigEditIntegration,
    ConfigRemoveIntegration,
  },
};
</script>

<style></style>
