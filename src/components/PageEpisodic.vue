<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card :title="display" shaped>
          <v-card-subtitle class="pb-4">
            <v-chip color="primary" variant="outlined" class="mx-2">
              Release Year: {{ item.year }}
            </v-chip>
            <v-chip color="primary" variant="outlined" class="mx-2">
              Genre: {{ item.genre }}
            </v-chip>
            <v-chip :color="activeColour" variant="outlined" class="mx-2">
              Active
            </v-chip>
            <v-chip color="success" variant="outlined" class="mx-2" v-if="item.path != ''">
              Path: {{ item.path }}
            </v-chip>
            <EpisodeGradiantChip :text="'Watched: '+meta.watched_episodes+' / '+meta.total_episodes" :gradient="Math.floor((meta.watched_episodes / meta.total_episodes) * 10)" />
            <EpisodicIntegrationModal :result="item" @updated="loadEpisodic" />
          </v-card-subtitle>

          <template v-slot:append>
            <EpisodicRefresh :id="id" />
            <EpisodicEdit :id="id" @editComplete="loadEpisodic" />
            <EpisodicRemove :id="id" :title="display" @removeComplete="mainListing" />
          </template>
        </v-card>
      </v-col>

      <v-col cols="12" v-if="hasSpecial">
        <v-card title="Specials" shaped>
          <v-data-table-virtual :headers="headers" :items="item.episodes" :custom-filter="filterForSeason" search="0" item-value="season_id">
          </v-data-table-virtual>
        </v-card>
      </v-col>

      <v-col cols="12" v-for="idx in seasonCount">
        <v-card :title="'Season '+idx" shaped>
          <v-data-table-virtual
            :headers="headers"
            :items="item.episodes"
            :custom-filter="filterForSeason"
            :search="idx"
            :sort-by="[{key: 'episode_number', order: 'asc'}]"
            item-value="season_id">

            <template v-slot:item.is_watched="{ item }">
              <v-btn
                variant="outlined"
                density="comfortable"
                :text="item.is_watched ? 'Watched' : 'Not watched'"
                :color="item.is_watched ? 'success' : 'primary'"
                @click="watched(item.id)" />
            </template>

          </v-data-table-virtual>
        </v-card>
      </v-col>

    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import EpisodeGradiantChip from '@/components/EpisodeGradiantChip';
import EpisodicEdit from '@/components/EpisodicEdit';
import EpisodicRefresh from '@/components/EpisodicRefresh';
import EpisodicRemove from '@/components/EpisodicRemove';
import EpisodicIntegrationModal from '@/components/EpisodicIntegrationModal';

export default {
  data: () => ({
    headers: [
      {title: 'Episode', align: 'center', key: 'episode_number'},
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Date Released', align: 'left', key: 'date_released'},
      {title: 'Watched?', align: 'center', key: 'is_watched', sortable: false},
      {title: 'File', align: 'left', key: 'file_entry'},
    ],
    item: {},
    display: '',
    hasSpecial: false,
    seasonCount: 0,
    activeColour: 'blue',
    meta: {},
  }),
  components: {
    EpisodeGradiantChip,
    EpisodicEdit,
    EpisodicRefresh,
    EpisodicRemove,
    EpisodicIntegrationModal,
  },
  computed: {
    ...mapState(['episodic']),
  },
  created() {
    this.loadEpisodic();
  },
  props: ['id'],
  methods: {
    filterForSeason(value, query, item) {
      return value != null &&
        query != null &&
        query.toString() === item.raw.season_id.toString();
    },

    loadEpisodic() {
      this.getEpisodic({id: this.id}).then(() => {
        this.item = this.episodic[this.id].episodic;
        this.meta = this.episodic[this.id].meta;

        this.display = `${this.item.title} (${this.item.year})`;
        this.item.episodes.forEach((idx) => {
          if (idx.season_id === 0) {
            this.hasSpecial = true;
          } else if (idx.season_id > this.seasonCount) {
            this.seasonCount = idx.season_id;
          }
        });
        this.activeColour = this.item.is_active ? 'success' : 'error';
      });
    },

    mainListing() {
      this.$router.push('/episodic');
    },

    watched(id) {
      this.$store.dispatch('markEpisodeWatched', { id: this.id, episode_id: id }).then((data) => {
        this.loadEpisodic();
      });
    },

    ...mapActions(['getEpisodic']),
  },
};
</script>

<style></style>
