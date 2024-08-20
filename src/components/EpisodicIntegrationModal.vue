<template>
  <v-chip
    color="error"
    variant="outlined"
    class="mx-2"
    v-if="result.public_db_id == ''"
    @click="open">

    Provider ID not associated!
  </v-chip>
  <v-chip
    color="success"
    variant="outlined"
    class="mx-2"
    v-if="result.public_db_id != ''">

    Provider ID: {{ result.public_db_id }}
  </v-chip>

  <v-dialog v-model="show" max-width="850">
    <v-card
      width="850"
      :loading="loading"
      title="Associating"
      class="mx-auto"
      subtitle="Select the appropriate entry">

      <v-card-text>

        <v-data-table-virtual :items="options" :headers="headers">
          <template v-slot:item.release_year="{ item }">
            <v-chip class="mx-2" variant="outlined" :text="item.release_year" />
          </template>

          <template v-slot:item.action="{ item }">
            <v-btn
              color="success"
              text="Select"
              variant="outlined"
              class="mx-2"
              @click="select(''+result.id, ''+item.id)"
              density="compact" />
          </template>
        </v-data-table-virtual>

      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Release year', align: 'left', key: 'release_year'},
      {title: 'Action', align: 'center', key: 'action', sortable: false},
    ],
    loading: false,
    options: [],
    show: false,
  }),
  props: ['result'],
  methods: {
    load() {
      this.loading = true;
      this.$store.dispatch('episodicSearchIntegration', {id: this.result.id, title: this.result.title}).then((opts) => {
        this.options = opts.data;
        this.loading = false;
      });
    },
    open() {
      this.load();
      this.show = true;
    },
    select(internal, external) {
      this.loading = true;
      this.$store.dispatch('episodicIntegrationIdentifier', {id: internal, payload: {external}}).then((opts) => {
        this.loading = false;
        this.show = false;

        this.$emit('updated');
      });
    },
  },
};
</script>

<style></style>
