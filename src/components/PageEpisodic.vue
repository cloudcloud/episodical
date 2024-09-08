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
            <EpisodeGradiantChip
              :text="'Watched: '+meta.total_episodes_watched+' / '+meta.total_episodes"
              :gradient="Math.floor((meta.total_episodes_watched / meta.total_episodes) * 10)" />
            <EpisodicIntegrationModal
              :result="item"
              @updated="loadEpisodic" />
          </v-card-subtitle>

          <template v-slot:append>
            <EpisodicRefresh :id="id" />
            <EpisodicEdit :id="id" @editComplete="loadEpisodic" />
            <EpisodicRemove :id="id" :title="display" @removeComplete="mainListing" />
          </template>
        </v-card>
      </v-col>

      <v-col cols="12" v-if="meta.total_specials_count > 0">
        <v-card title="Specials" shaped>
          <template v-slot:append>
            <v-btn
              text="Mark all watched"
              color="primary"
              @click="allWatched(''+0)"
              variant="outlined"
              density="comfortable" />
          </template>

          <v-data-table-virtual
            :headers="headers"
            :items="item.episodes"
            :custom-filter="filterForSeason"
            search="0"
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

      <v-col cols="12" v-for="idx in seasons">
        <v-card :title="'Season '+idx" shaped>
          <template v-slot:append>
            <v-btn
              text="Mark all watched"
              color="primary"
              @click="allWatched(''+idx)"
              variant="outlined"
              density="comfortable" />
          </template>

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
import { mapActions, mapGetters } from 'vuex';
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
    meta: {},
    display: '',
    seasons: [],
    activeColour: 'blue',
  }),
  components: {
    EpisodeGradiantChip,
    EpisodicEdit,
    EpisodicRefresh,
    EpisodicRemove,
    EpisodicIntegrationModal,
  },
  computed: {
    ...mapGetters(['episodicById']),
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
        this.item = this.episodicById(this.id);
        this.meta = this.item.meta;

        this.display = `${this.item.title} (${this.item.year})`;
        this.seasons = this.meta.seasons.split(',');
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

    allWatched(season) {
      this.$store.dispatch('markSeasonWatched', { id: this.id, season_id: season }).then((data) => {
        this.loadEpisodic();
      });
    },

    ...mapActions(['getEpisodic']),
  },
};
</script>

<style></style>
