import polars
import glob

if __name__ == "__main__":
    master_file = "InfrasThemeDetails_complete.csv"
    result_files = list(filter(lambda x: "Summary" not in x,
                               glob.glob("KasiaKuleszewicz/Final/*.csv")))

    master_file = polars.read_csv(master_file)

    for a_file in result_files:
        d = polars.read_csv(a_file)

        for a_row in d.iter_rows(named=True):
            try:
                master_file_row = master_file.filter(Reference=a_row["Reference"], Theme=a_row["Theme"])
            except KeyError:
                import pdb
                pdb.set_trace()
            if len(master_file_row) > 1:
                print("ERROR")
            else:
                round_normalised = master_file_row["Theme"][0].lower().replace(" ","_").replace("(", "_").replace(")","_").replace("/","_").replace("&","_").replace(",","_").replace("'","_").replace(";", "_")
                with open(f"KasiaKuleszewicz/Final/PES/{master_file_row['Reference'][0]}_{round_normalised}.md", "wt") as fd:
                    fd.write(f"# {master_file_row['Reference'][0]}\n\n")
                    text_to_write = str(master_file_row['Details'][0]).replace("   ","\n")
                    fd.write(f"# Plain English Summary\n{text_to_write}\n")
