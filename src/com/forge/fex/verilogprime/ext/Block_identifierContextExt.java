package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Block_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Block_identifierContextExt extends AbstractBaseExt {

	public Block_identifierContextExt(Block_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Block_identifierContext getContext() {
		return (Block_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).block_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Block_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Block_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}