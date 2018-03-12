package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IHashTable;
import com.forge.parser.gen.ForgeParser.Hash_hintContext;
import com.forge.parser.gen.ForgeParser.Hash_propertiesContext;
import com.forge.parser.gen.ForgeParser.HashtableContext;
import com.forge.parser.gen.ForgeParser.Hint_zerotime_actionContext;

public class HashtableContextExt extends AbstractBaseExt implements IHashTable{
	private Logger L = LoggerFactory.getLogger(HashtableContextExt.class);

	public HashtableContextExt(HashtableContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public HashtableContext getContext() {
		return (HashtableContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hashtable());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof HashtableContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + HashtableContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	protected int offset;

	@Override
	public void calculateMemoryOffset(AtomicInteger offset) {
		super.calculateMemoryOffset(offset);
		this.offset = offset.get();
	}

	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		HashtableContext ctx = getContext();
		for (int i = 0; i < ctx.hash_properties().size(); i++) {
			offset.set(0);
			if (ctx.hash_properties(i).key() != null) {
				getExtendedContextVisitor().visit(ctx.hash_properties(i)).calculateFieldOffset(offset);
			}
		}

		for (int i = 0; i < ctx.hash_properties().size(); i++) {
			offset.set(0);
			if (ctx.hash_properties(i).value() != null) {
				getExtendedContextVisitor().visit(ctx.hash_properties(i)).calculateFieldOffset(offset);
			}
		}
	}

	@Override
	public void requiredPropertyCheck() {
		HashtableContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		propStore.put("propName", ctx.HASHTABLE().getText());
		for (int i = 0; i < ctx.hash_properties().size(); i++) {
			ctx.hash_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("words")) {
			throw new IllegalStateException("In Hashtable words not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("bits")) {
			throw new IllegalStateException("In Hashtable bits not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("portCap")) {
			throw new IllegalStateException("In Hashtable PortCap not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("buckets")) {
			throw new IllegalStateException("In Hashtable buckets not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("key")) {
			throw new IllegalStateException("In Hashtable key is  not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("value")) {
			throw new IllegalStateException("In Hashtable value is not present in line " + ctx.start.getLine());
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		HashtableContext ctx = getContext();
		List<String> keyInHashtable = new ArrayList<>();
		for (Hash_propertiesContext hash_properties : ctx.hash_properties()) {
			hash_properties.extendedContext.duplicateNamesCheck("Hashtable", keyInHashtable);
		}
	}

	@Override
	public List<String> getModuleNames() {
		List<String> moduleNames = new ArrayList<String>();
		HashtableContext ctx = getContext();
		for(Hash_propertiesContext hash_propertiesContext : ctx.hash_properties()){
			if(hash_propertiesContext.hash_hint() != null && !hash_propertiesContext.hash_hint().extendedContext.getFormattedText().equals("")){
				Hash_hintContext hash_hintContext = hash_propertiesContext.hash_hint();
				for(Hint_zerotime_actionContext hint_zerotime_actionContext : hash_hintContext.hint_zerotime_action()){
					String moduleName = hint_zerotime_actionContext.hint_zerotime_action_part1().hint_zerotime_identifier().extendedContext.getFormattedText();
					moduleNames.add(moduleName);
				}
			}
		}
		return moduleNames;
	}
}
