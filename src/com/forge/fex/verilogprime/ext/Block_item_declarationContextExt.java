package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Block_item_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Block_item_declarationContextExt extends AbstractBaseExt {

	public Block_item_declarationContextExt(Block_item_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Block_item_declarationContext getContext() {
		return (Block_item_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).block_item_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Block_item_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Block_item_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}