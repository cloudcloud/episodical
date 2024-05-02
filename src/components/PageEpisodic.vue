<template>
  <v-container>
    <v-row>
      <v-col cols="12">

        <v-card shaped title="Episodics">
          <template v-slot:append>
            <v-btn
              prepend-icon="mdi-plus"
              @click="add"
              ripple
              text="Add New Episodical" />
          </template>
        </v-card>

      </v-col>
    </v-row>
  </v-container>

  <v-dialog v-model="dialog" max-width="500">
    <v-card :loading="loading" class="mx-auto" title="Add New Episodical" width="500">
      <v-card-text>
        <v-form ref="add">
          <v-text-field
            v-model="title"
            :rules="[rules.required]"
            label="Title"
            required />

          <v-text-field
            v-model="year"
            :rules="[rules.required, rules.numerical]"
            label="Release Year"
            required />

        </v-form>
      </v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn @click="close">Cancel</v-btn>
        <v-btn @click="save" color="primary">Add</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    dialog: false,
    loading: false,
    rules: {
      numerical: v => !/[^0-9]+/.test(v) || 'Numbers only.',
      required: v => !!v || 'Required.',
    },

    title: '',
    year: 2000,
  }),
  methods: {
    add() {
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    },
    save() {
      this.loading = true;
    },
  },
};
</script>

<style></style>
