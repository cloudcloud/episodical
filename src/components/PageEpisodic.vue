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
            <v-chip :color="activeColour()" variant="outlined" class="mx-2">
              Active
            </v-chip>
            <v-chip color="success" variant="outlined" class="mx-2" v-if="item.filesystem_id != ''">
              Path: {{ item.path }}
            </v-chip>
            <v-chip color="success" variant="outlined" class="mx-2" v-if="item.integration_id != ''">
              Integration Enabled!
            </v-chip>
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
          <v-data-table-virtual :headers="headers" :items="item.episodes" :custom-filter="filterForSeason" :search="idx" item-value="season_id">
            <template v-slot:item.is_watched="{ item }">
              <v-btn variant="outlined" text="Watched!" color="success" v-if="item.is_watched" />
              <v-btn variant="outlined" text="Not Watched" color="info" v-if="!item.is_watched" />
            </template>
          </v-data-table-virtual>
        </v-card>
      </v-col>

    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import EpisodicEdit from '@/components/EpisodicEdit';
import EpisodicRefresh from '@/components/EpisodicRefresh';
import EpisodicRemove from '@/components/EpisodicRemove';
import EpisodicIntegrationModal from '@/components/EpisodicIntegrationModal';

export default {
  data: () => ({
    headers: [
      {title: 'Episode', align: 'center', key: 'episode_number'},
      {title: 'Title', align: 'left', key: 'title'},
      {title: 'Date Aired', align: 'left', key: 'date_first_aired'},
      {title: 'Watched?', align: 'center', key: 'is_watched'},
      {title: 'File', align: 'left', key: 'file_entry'},
    ],
    item: {},
    display: '',
    hasSpecial: false,
    seasonCount: 0,
  }),
  components: {
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
    activeColour() {
      if (this.item.is_active) {
        return "success";
      } else {
        return "error";
      }
    },

    filterForSeason(value, query, item) {
      return value != null &&
        query != null &&
        query.toString() === item.raw.season_id.toString();
    },

    loadEpisodic() {
      this.getEpisodic({id: this.id}).then(() => {
        this.item = this.episodic[this.id];
        this.display = `${this.item.title} (${this.item.year})`;
        this.item.episodes.forEach((idx) => {
          if (idx.season_id === 0) {
            this.hasSpecial = true;
          } else if (idx.season_id > this.seasonCount) {
            this.seasonCount = idx.season_id;
          }
        });
      });
    },

    mainListing() {
      this.$router.push('/episodic');
    },

    ...mapActions(['getEpisodic']),
  },
};
</script>

<style></style>
