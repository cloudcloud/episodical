<template>
  <v-container>
    <v-row>
      <v-col cols="12">

        <v-card shaped title="Episodics">
          <template v-slot:append>
            <EpisodicAdd @addComplete="loadEpisodics" />
          </template>

          <v-data-table-virtual
            :headers="headers"
            :items="items"
            density="comfortable"
            multi-sort
            :sort-by="[{ key: 'meta.total_episode_files', order: 'asc' }]">

            <template v-slot:item.title="{ item }">
              <v-btn variant="text" density="comfortable" class="text-none" :to="'/episodic/' + item.id">
                {{ item.title }} ({{ item.year }})
              </v-btn>
            </template>
            <template v-slot:item.meta.total_episode_files="{ item }">
              <EpisodeGradiantChip
                :text="'Files: '+item.meta.total_episode_files+' / '+item.meta.total_episodes"
                :gradient="Math.floor((item.meta.total_episode_files/item.meta.total_episodes) * 10)" />
            </template>
            <template v-slot:item.meta.total_episodes_watched="{ item }">
              <EpisodeGradiantChip
                :text="'Watched: '+item.meta.total_episodes_watched+' / '+item.meta.total_episodes"
                :gradient="Math.floor((item.meta.total_episodes_watched/item.meta.total_episodes) * 10)" />
            </template>
            <template v-slot:item.status="{ item }">
              <v-chip density="comfortable" :text="item.is_active ? 'Active' : 'Ended'" :color="item.is_active ? 'green' : 'red'" variant="outlined" />
            </template>
            <template v-slot:item.available="{ item }">
              <v-chip density="comfortable" :text="item.meta.next_episode_date" v-if="item.meta.next_episode_date != ''" variant="outlined" />
            </template>

          </v-data-table-virtual>
        </v-card>

      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from 'vuex';
import EpisodeGradiantChip from '@/components/EpisodeGradiantChip';
import EpisodicAdd from '@/components/EpisodicAdd';

export default {
  data: () => ({
    headers: [
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Files', align: 'center', key: 'meta.total_episode_files' },
      {title: 'Watched', align: 'center', key: 'meta.total_episodes_watched' },
      {title: 'Status', align: 'center', key: 'status', sortable: false},
      {title: 'Next Ep', align: 'center', key: 'available', sortable: false},
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
        this.items = this.$store.getters.allEpisodics;
      });
    },
    ...mapMutations(['resetEpisodics']),
    ...mapActions(['getEpisodics']),
  },
  components: {
    EpisodeGradiantChip,
    EpisodicAdd,
  },
};
</script>

<style scoped>
.active {
  text-decoration: none;
}
</style>
