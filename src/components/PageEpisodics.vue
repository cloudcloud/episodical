<template>
  <v-container>
    <v-row>
      <v-col cols="12">

        <v-card shaped title="Episodics">
          <template v-slot:append>
            <EpisodicAdd @addComplete="loadEpisodics" />
          </template>

          <v-data-table-virtual :headers="headers" :items="items">

            <template v-slot:item.title="{ item }">
              <v-btn variant="text" density="comfortable" class="text-none" :to="'/episodic/' + item.id">
                {{ item.title }} ({{ item.year }})
              </v-btn>
            </template>
            <template v-slot:item.files="{ item }">
              <v-chip density="comfortable" :text="meta[item.id].have_episode_files+' / '+meta[item.id].total_episodes" />
            </template>
            <template v-slot:item.status="{ item }">
              <v-chip density="comfortable" text="Unknown" />
            </template>
            <template v-slot:item.available="{ item }">
              <v-chip density="comfortable" text="Available" />
            </template>
            <template v-slot:item.watched="{ item }">
              <v-chip density="comfortable" :text="meta[item.id].watched_episodes+' / '+meta[item.id].total_episodes" />
            </template>

          </v-data-table-virtual>
        </v-card>

      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from 'vuex';
import EpisodicAdd from '@/components/EpisodicAdd';

export default {
  data: () => ({
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Files', align: 'center', key: 'files'},
      {title: 'Watched', align: 'center', key: 'watched'},
      {title: 'Available', align: 'center', key: 'available'},
      {title: 'Next Ep', align: 'center', key: 'status'},
    ],
    items: [],
  }),
  computed: {
    ...mapGetters(['allEpisodics']),
  },
  created() {
    this.loadEpisodics();
  },
  methods: {
    loadEpisodics() {
      this.$store.dispatch('getEpisodics').then(() => {
        this.items = this.$store.getters.allEpisodics.episodics;
        this.meta = this.$store.getters.allEpisodics.meta;
      });
    },
    ...mapMutations(['resetEpisodics']),
    ...mapActions(['getEpisodics']),
  },
  components: {
    EpisodicAdd,
  },
};
</script>

<style scoped>
.active {
  text-decoration: none;
}
</style>
