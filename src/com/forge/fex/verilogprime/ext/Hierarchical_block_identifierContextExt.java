package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hierarchical_block_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hierarchical_block_identifierContextExt extends AbstractBaseExt {

	public Hierarchical_block_identifierContextExt(Hierarchical_block_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hierarchical_block_identifierContext getContext() {
		return (Hierarchical_block_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hierarchical_block_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hierarchical_block_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hierarchical_block_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}