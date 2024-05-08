<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card :title="display" shaped>
          <v-card-subtitle>
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
          </v-card-subtitle>

          <template v-slot:append>
            <EpisodicEdit :id="id" @editComplete="loadEpisodic" />
            <EpisodicRemove :id="id" :title="display" @removeComplete="mainListing" />
          </template>

          <!--
            loop for seasons, including the specials if there is one
            have a data table, along with a title, for each

            season could be a component?
              each episode can be marked as watched, along with a season to do all of them at once

            <v-data-table :headers="headers" :items="item.episodes">
            </v-data-table>
          -->

        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import EpisodicEdit from '@/components/EpisodicEdit';
import EpisodicRemove from '@/components/EpisodicRemove';

export default {
  data: () => ({
    headers: [],
    item: {},
    display: '',
  }),
  components: {
    EpisodicEdit,
    EpisodicRemove,
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
    loadEpisodic() {
      this.getEpisodic({id: this.id}).then(() => {
        this.item = this.episodic[this.id];
        this.display = `${this.item.title} (${this.item.year})`;
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
